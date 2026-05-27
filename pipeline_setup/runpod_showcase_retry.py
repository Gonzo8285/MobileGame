#!/usr/bin/env python3
"""
Auto-retry wrapper for runpod_showcase_batch.py.

RunPod community/secure capacity is currently dry RunPod-wide. Failed deploys
are free and fast (~6s, no pod = no spend), so we poll: re-attempt the full
batch every RETRY_INTERVAL_SEC until it succeeds (exit 0) or the wall-clock
budget (MAX_WALL_SEC) is exhausted.

Runs detached from the Claude tool lifecycle (launched via Start-Process), so
it persists past any single tool-call timeout. Progress -> .showcase_retry.log.

Stop early by killing the python process or deleting the STOP sentinel guard:
  create pipeline_setup/.showcase_retry.STOP  -> wrapper exits before next try.
"""
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
BATCH = HERE / "runpod_showcase_batch.py"
RETRY_LOG = HERE / ".showcase_retry.log"
STOP_SENTINEL = HERE / ".showcase_retry.STOP"

RETRY_INTERVAL_SEC = 1200      # 20 min between attempts
MAX_WALL_SEC = 6 * 3600        # 6 hour hard cap

# One or more manifests:
#   python runpod_showcase_retry.py m1.json m2.json ...
# Each manifest is retried until it succeeds, then the next runs — all within
# the shared wall budget. No args -> the default 12-tile showcase.
MANIFEST_ARGS = sys.argv[1:] if len(sys.argv) > 1 else [None]


def rlog(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] [retry] {msg}"
    print(line, flush=True)
    try:
        with RETRY_LOG.open("a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass


def run_one(manifest, start, deadline):
    """Retry a single manifest until it succeeds or the shared budget runs
    out. Returns 'ok' | 'gaveup' | 'stop'."""
    label = manifest or "(default 12-tile)"
    attempt = 0
    while True:
        if STOP_SENTINEL.exists():
            rlog(f"STOP sentinel found — exiting before attempt [{label}].")
            return "stop"
        attempt += 1
        rlog(f"--- [{label}] attempt {attempt} "
             f"(elapsed {int(time.time()-start)}s) ---")
        try:
            cmd = [sys.executable, str(BATCH)]
            if manifest:
                cmd.append(manifest)
            proc = subprocess.run(cmd, cwd=str(HERE.parent),
                                  capture_output=True, text=True,
                                  timeout=max(60, int(deadline - time.time())))
            rc = proc.returncode
        except subprocess.TimeoutExpired:
            rlog("attempt exceeded wall budget mid-run — aborting.")
            return "gaveup"
        except Exception as e:
            rc = -1
            rlog(f"attempt raised: {type(e).__name__}: {e}")

        tail = ""
        try:
            blog = HERE / ".showcase_batch_status.log"
            if blog.exists():
                tail = blog.read_text(encoding="utf-8",
                                      errors="replace").splitlines()[-1]
        except Exception:
            pass

        if rc == 0:
            rlog(f"[{label}] attempt {attempt} SUCCEEDED. Last: {tail}")
            return "ok"

        capacity = "no capacity" in tail or "exhausted" in tail
        rlog(f"[{label}] attempt {attempt} failed rc={rc} "
             f"({'capacity' if capacity else 'other'}). Last: {tail}")

        if time.time() + RETRY_INTERVAL_SEC > deadline:
            rlog(f"[{label}] GAVE UP after {attempt} attempts "
                 f"(budget exhausted)")
            return "gaveup"

        slept = 0
        while slept < RETRY_INTERVAL_SEC:
            if STOP_SENTINEL.exists():
                rlog("STOP sentinel found during wait — exiting.")
                return "stop"
            time.sleep(15)
            slept += 15


def main():
    try:
        RETRY_LOG.unlink(missing_ok=True)
    except Exception:
        pass
    start = time.time()
    deadline = start + MAX_WALL_SEC
    rlog(f"=== retry wrapper start; interval={RETRY_INTERVAL_SEC}s "
         f"budget={MAX_WALL_SEC // 3600}h "
         f"manifests={len(MANIFEST_ARGS)}: "
         f"{[m or 'default' for m in MANIFEST_ARGS]} ===")

    done, failed = [], []
    for i, manifest in enumerate(MANIFEST_ARGS, 1):
        rlog(f"=== manifest {i}/{len(MANIFEST_ARGS)}: "
             f"{manifest or '(default)'} ===")
        result = run_one(manifest, start, deadline)
        if result == "ok":
            done.append(manifest)
        elif result == "stop":
            rlog(f"=== STOPPED. done={len(done)} remaining="
                 f"{len(MANIFEST_ARGS)-len(done)} ===")
            return 2
        else:  # gaveup (budget exhausted) — stop the whole sequence
            failed.append(manifest)
            rlog(f"=== BUDGET EXHAUSTED at manifest {i}. "
                 f"done={len(done)} not-run={len(MANIFEST_ARGS)-i} ===")
            return 1

    rlog(f"=== retry wrapper done: ALL {len(done)} manifest(s) SUCCEEDED ===")
    return 0


if __name__ == "__main__":
    sys.exit(main())

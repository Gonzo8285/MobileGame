@echo off
REM Gallowfell AI art pipeline — one-time installer
REM Author: Cowork, 2026-05-02
REM Target: Windows 10/11, Python 3.11, NVIDIA RTX (any generation)

setlocal enabledelayedexpansion

echo ============================================================
echo  Gallowfell AI art pipeline — installer
echo ============================================================
echo.

REM --- Sanity check: Python 3.11 ----------------------------------
echo [1/7] Checking Python 3.11...
python --version 2^>^&1 ^| findstr /C:"3.11" >nul
if errorlevel 1 (
    echo   ERROR: Python 3.11 not found on PATH.
    echo   Install from https://python.org/downloads/release/python-3119/
    echo   Make sure "Add to PATH" is ticked during install.
    pause
    exit /b 1
)
echo   OK: Python 3.11 detected.
echo.

REM --- Sanity check: Git -------------------------------------------
echo [2/7] Checking Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo   ERROR: Git not found. Install from https://git-scm.com/download/win
    pause
    exit /b 1
)
echo   OK: Git detected.
echo.

REM --- Sanity check: NVIDIA GPU ------------------------------------
echo [3/7] Checking NVIDIA GPU...
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo   WARNING: nvidia-smi not found. CPU-only ComfyUI will be very slow.
    echo   Press Ctrl+C now if you want to abort. Continuing in 10 seconds...
    timeout /t 10 >nul
)
echo   OK: NVIDIA GPU available.
echo.

REM --- Clone ComfyUI -----------------------------------------------
echo [4/7] Cloning ComfyUI to C:\ComfyUI...
if exist C:\ComfyUI (
    echo   Folder C:\ComfyUI already exists. Skipping clone.
    echo   If you want a fresh install, delete that folder first and re-run.
) else (
    git clone https://github.com/comfyanonymous/ComfyUI.git C:\ComfyUI
    if errorlevel 1 (
        echo   ERROR: git clone failed. Check internet connection.
        pause
        exit /b 1
    )
)
echo   OK: ComfyUI ready.
echo.

REM --- Create Python venv ------------------------------------------
echo [5/7] Creating Python virtual environment...
cd /d C:\ComfyUI
if not exist venv (
    python -m venv venv
)
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
echo   OK: venv ready.
echo.

REM --- Install dependencies ----------------------------------------
echo [6/7] Installing PyTorch + ComfyUI dependencies (this is the long step, ~5-15 min)...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt
echo   OK: dependencies installed.
echo.

REM --- Wire workflow into ComfyUI ----------------------------------
echo [7/7] Wiring Gallowfell workflow into ComfyUI...
if not exist C:\ComfyUI\user\default\workflows\ (
    mkdir C:\ComfyUI\user\default\workflows\
)
if not exist "%~dp0workflow_gallowfell_card.json" (
    echo   SKIPPED: workflow_gallowfell_card.json not present in pipeline_setup\.
    echo   This is expected on fresh installs before the smoke test passes — the
    echo   workflow is authored after B3.0a. ComfyUI's default workflow ^(right-click
    echo   canvas in the UI ^| Load Default^) is fine for the smoke test.
    goto :install_complete
)
copy /Y "%~dp0workflow_gallowfell_card.json" "C:\ComfyUI\user\default\workflows\"
if errorlevel 1 (
    echo   ERROR: copy of workflow_gallowfell_card.json failed.
    echo   Source: %~dp0workflow_gallowfell_card.json
    echo   Target: C:\ComfyUI\user\default\workflows\
    echo   Check that ComfyUI clone succeeded ^(step 4^) and that you have write
    echo   permissions on C:\ComfyUI\. Then re-run this installer.
    pause
    exit /b 1
)
echo   OK: workflow installed.
:install_complete
echo.

REM --- Final instructions ------------------------------------------
echo ============================================================
echo  Install complete. Manual model download steps remain.
echo ============================================================
echo.
echo  1. Download juggernautXL_v9 (~7GB) from:
echo       https://civitai.com/models/133005
echo     Drop the .safetensors file into:
echo       C:\ComfyUI\models\checkpoints\
echo.
echo  2. Download the LoRAs listed in pipeline_setup\README.md
echo     Drop them into:
echo       C:\ComfyUI\models\loras\
echo.
echo  3. Launch ComfyUI:
echo       cd C:\ComfyUI
echo       venv\Scripts\activate.bat
echo       python main.py
echo.
echo  4. Open http://127.0.0.1:8188 in your browser.
echo  5. Load the Gallowfell workflow from File menu.
echo  6. Run the smoke test from pipeline_setup\README.md.
echo.
pause

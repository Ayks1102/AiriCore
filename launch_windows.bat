@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul 2>nul
title AiriCore launcher (Windows)

set "ENV_NAME=airicore"
set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%" || (
    echo [ERROR] Cannot enter project directory: %PROJECT_DIR%
    pause
    exit /b 1
)
set "LANG=en_US.UTF-8"

echo [INFO] AiriCore launcher (Windows)
echo [INFO] Project directory: %PROJECT_DIR%

set "CONDA_BAT="
if exist "%USERPROFILE%\miniconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\miniconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "%USERPROFILE%\anaconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\anaconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "C:\ProgramData\miniconda3\condabin\conda.bat" set "CONDA_BAT=C:\ProgramData\miniconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "C:\ProgramData\Anaconda3\condabin\conda.bat" set "CONDA_BAT=C:\ProgramData\Anaconda3\condabin\conda.bat"

if not defined CONDA_BAT (
    where conda >nul 2>nul
    if not errorlevel 1 (
        for /f "delims=" %%B in ('conda info --base 2^>nul') do set "CONDA_BASE=%%B"
        if defined CONDA_BASE if exist "!CONDA_BASE!\condabin\conda.bat" set "CONDA_BAT=!CONDA_BASE!\condabin\conda.bat"
    )
)

if not defined CONDA_BAT (
    echo [ERROR] conda was not found. Please run deploy_windows.ps1 first.
    pause
    exit /b 1
)

echo [INFO] Using conda: !CONDA_BAT!
call "!CONDA_BAT!" activate %ENV_NAME%
if errorlevel 1 (
    echo [ERROR] Failed to activate conda env "%ENV_NAME%". Please run the deploy script first.
    pause
    exit /b 1
)

echo [INFO] Starting AiriCore (auto-restart is handled in bot.py)
python bot.py
pause

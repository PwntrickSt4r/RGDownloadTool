@echo off
cd /d "%~dp0"
title 7-Zip Auto-Extractor (x86 Compatible)
color 0e

:: --- SETTINGS ---
set "sevenzip_exe=%~dp0binaries\7za.exe"
set "target_dir=tmp"
set "pass=ms_by_rgadguard"

echo =======================================================
echo         7-Zip Auto-Extractor for RGDownloadTool
echo =======================================================
echo.

:: 1. Check if 7za.exe exists
if not exist "%sevenzip_exe%" (
    color 0c
    echo ERROR: Cannot find 7za.exe in "binaries" folder!
    pause
    exit
)

:: 2. Check if tmp folder exists
if not exist "%target_dir%" (
    color 0e
    echo [!] Folder "%target_dir%" not found. 
    echo Please make sure your archives are inside the "tmp" folder.
    pause
    exit
)

echo [SCAN] Looking for .7z archives in /%target_dir%...
echo.

:: 3. Extraction Loop
set "found=0"
for %%F in ("%target_dir%\*.7z*") do (
    set "found=1"
    echo -------------------------------------------------------
    echo [WORKING] Extracting: "%%~nxF"
    echo [DEST] To folder: "%%~dpnF"
    
    :: x - extract, -p - password, -o - output to folder with same name, -y - yes to all
    "%sevenzip_exe%" x "%%~fF" -p%pass% -o"%%~dpnF" -y
    
    if %errorlevel% equ 0 (
        echo [OK] Successfully unpacked!
    ) else (
        echo [!] Error unpacking "%%~nxF". Check integrity.
    )
)

if "%found%"=="0" (
    echo [SKIP] No .7z archives found in "/%target_dir%".
)

echo.
echo =======================================================
echo     FINISHED! All found archives processed.
echo =======================================================
pause
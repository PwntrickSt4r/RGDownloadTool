@echo off
cd /d "%~dp0"
title RGDownloadTool v1.1 (x86 Compatible)
color 0b

:: --- SETTINGS ---
set "aria2_exe=%~dp0binaries\aria2c.exe"
set "server=https://files.rg-adguard.net"
set "key=free"
set "pass=ms_by_rgadguard"

echo =======================================================
echo                 RGDownloadTool v1.1
echo                 Made by PwntrickSt4r
echo =======================================================
echo.

:: 1. Check if aria2c exists
if not exist "%aria2_exe%" (
    color 0c
    echo ERROR: Cannot find aria2c.exe in "binaries" folder!
    echo Please place the 32-bit aria2c.exe inside the binaries folder.
    pause
    exit
)

:: 2. Prompt for UUID
echo Please enter the UUID of the file you want to download.
set /p "uuid=UUID: "

if "%uuid%"=="" (
    echo ERROR: UUID cannot be empty!
    pause
    exit
)

echo.
:: 3. Get file list
echo [1/2] Fetching file list from server...
"%aria2_exe%" --allow-overwrite=true -o "list.txt" "%server%/file/%uuid%/list" --disable-ipv6
if %errorlevel% neq 0 (echo Error fetching list! & pause & exit)

:: 4. Generate direct download links
echo [2/2] Generating download links...
"%aria2_exe%" --allow-overwrite=true -o "dl.txt" "%server%/dl/%key%/%uuid%" --disable-ipv6
if %errorlevel% neq 0 (echo Error generating links! & pause & exit)

:: 5. Start downloading
echo.
echo [3/3] STARTING DOWNLOAD (This may take a while)...
echo -------------------------------------------------------
"%aria2_exe%" -i "dl.txt" -j1 -x16 -s16 -c -R --disable-ipv6

:: --- AUTO START EXTRACTOR ---
if exist "extractall.cmd" (
    echo.
    echo [INFO] Starting automatic extraction...
    timeout /t 2 /nobreak >nul
    call "extractall.cmd"
)

echo.
echo =======================================================
echo     FINISHED! All processes completed.
echo.
echo     Archive password (if needed): %pass%
echo =======================================================
pause
@echo off
title ASHH Optimizer - Build System (BMW M Edition)
color 0B

echo ===============================================================================
echo          /// ASHH OPTIMIZER - AUTOMATED BUILD PIPELINE (BMW M EDITION)
echo ===============================================================================
echo.

:: 1. Check dotnet CLI
where dotnet >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [ERROR] .NET SDK is not found in PATH.
    echo Please install .NET 10 SDK from https://dotnet.microsoft.com/download
    echo.
    pause
    exit /b 1
)

echo [*] .NET SDK Found:
dotnet --version
echo.

:: Navigate to script directory
cd /d "%~dp0"

:: 2. Clean previous build outputs
echo [*] Cleaning previous build artifacts...
if exist ".\Output\Publish" rmdir /s /q ".\Output\Publish"
if exist ".\Output\AshhOptimizer-Portable" rmdir /s /q ".\Output\AshhOptimizer-Portable"
if exist ".\Output\AshhOptimizer_Setup.exe" del /f /q ".\Output\AshhOptimizer_Setup.exe"
mkdir ".\Output\Publish\OptimizerUI" 2>nul
mkdir ".\Output\Publish\Service" 2>nul
mkdir ".\Output\AshhOptimizer-Portable\Service" 2>nul

echo.
echo ===============================================================================
echo [1/3] Building and Publishing ASHH Optimizer Background Service (win-x64)...
echo ===============================================================================
dotnet publish ".\AshhOptimizer.Service\AshhOptimizer.Service.csproj" -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -o ".\Output\Publish\Service"
if errorlevel 1 (
    color 0C
    echo [ERROR] Failed to compile ASHH Optimizer Service.
    pause
    exit /b 1
)

echo.
echo ===============================================================================
echo [2/3] Building and Publishing ASHH Optimizer UI Application (win-x64 Standalone)...
echo ===============================================================================
dotnet publish ".\OptimizerUI\OptimizerUI.csproj" -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:EnableCompressionInSingleFile=true -o ".\Output\Publish\OptimizerUI"
if errorlevel 1 (
    color 0C
    echo [ERROR] Failed to compile ASHH Optimizer UI.
    pause
    exit /b 1
)

echo.
echo [*] Preparing Portable Package in .\Output\AshhOptimizer-Portable...
copy /y ".\Output\Publish\OptimizerUI\ASHH Optimizer.exe" ".\Output\AshhOptimizer-Portable\" >nul
if exist ".\Output\Publish\OptimizerUI\appsettings.json" copy /y ".\Output\Publish\OptimizerUI\appsettings.json" ".\Output\AshhOptimizer-Portable\" >nul
copy /y ".\Output\Publish\Service\AshhOptimizer.Service.exe" ".\Output\AshhOptimizer-Portable\Service\" >nul 2>nul

echo.
echo ===============================================================================
echo [3/3] Building Setup Installer with Inno Setup...
echo ===============================================================================

set "ISCC_PATH="
if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "ISCC_PATH=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
if "%ISCC_PATH%"=="" if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "ISCC_PATH=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if "%ISCC_PATH%"=="" if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "ISCC_PATH=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if "%ISCC_PATH%"=="" (
    where ISCC.exe >nul 2>&1
    if not errorlevel 1 set "ISCC_PATH=ISCC.exe"
)

if not "%ISCC_PATH%"=="" (
    echo [*] Inno Setup compiler found at: "%ISCC_PATH%"
    echo [*] Compiling setup installer...
    "%ISCC_PATH%" ".\setup_v2.iss"
    if errorlevel 1 (
        echo [WARNING] Inno Setup compiler returned an error code.
    ) else (
        echo [OK] Setup Installer generated successfully.
    )
) else (
    echo [INFO] Inno Setup compiler not found in standard paths.
    echo Standalone EXEs are ready in .\Output\AshhOptimizer-Portable and .\Output\Publish.
)

echo.
color 0A
echo ===============================================================================
echo                     BUILD COMPLETED SUCCESSFULLY
echo ===============================================================================
echo.
echo Generated Executables and Outputs:
echo   1. Standalone UI Exe:       .\Output\Publish\OptimizerUI\ASHH Optimizer.exe
echo   2. Service Exe:             .\Output\Publish\Service\AshhOptimizer.Service.exe
echo   3. Portable Release Folder: .\Output\AshhOptimizer-Portable\
if exist ".\Output\AshhOptimizer_Setup.exe" (
echo   4. Setup Installer Exe:     .\Output\AshhOptimizer_Setup.exe
)
echo.
echo ===============================================================================
pause

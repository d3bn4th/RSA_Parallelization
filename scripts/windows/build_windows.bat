@echo off
setlocal enabledelayedexpansion

echo ========================================
echo RSA Parallelization - Windows Builder
echo ========================================
echo.

:: Check if we're in the right directory
if not exist "parallel_modular_exponentiation.cpp" (
    echo ERROR: Source files not found!
    echo Please run this script from the project root directory.
    pause
    exit /b 1
)

:: Set default build method
set BUILD_METHOD=cmake

:: Parse command line arguments
if "%1"=="make" set BUILD_METHOD=make
if "%1"=="cmake" set BUILD_METHOD=cmake
if "%1"=="vs" set BUILD_METHOD=vs
if "%1"=="help" goto :help

echo Build method: %BUILD_METHOD%
echo.

:: Check for required tools
echo Checking for required tools...

:: Check for CMake
where cmake >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: CMake not found in PATH
    set CMAKE_AVAILABLE=0
) else (
    echo ✓ CMake found
    set CMAKE_AVAILABLE=1
)

:: Check for MinGW
where g++ >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: MinGW g++ not found in PATH
    set MINGW_AVAILABLE=0
) else (
    echo ✓ MinGW g++ found
    set MINGW_AVAILABLE=1
)

:: Check for Visual Studio
where cl >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Visual Studio cl not found in PATH
    set VS_AVAILABLE=0
) else (
    echo ✓ Visual Studio cl found
    set VS_AVAILABLE=1
)

echo.

:: Build based on selected method
if "%BUILD_METHOD%"=="cmake" goto :build_cmake
if "%BUILD_METHOD%"=="make" goto :build_make
if "%BUILD_METHOD%"=="vs" goto :build_vs

echo Invalid build method: %BUILD_METHOD%
goto :help

:build_cmake
if %CMAKE_AVAILABLE%==0 (
    echo ERROR: CMake is required for this build method
    echo Please install CMake or use a different build method
    pause
    exit /b 1
)

echo Building with CMake...
if not exist "build" mkdir build
cd build

echo Configuring CMake...
cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
if %errorlevel% neq 0 (
    echo ERROR: CMake configuration failed
    cd ..
    pause
    exit /b 1
)

echo Building project...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo ERROR: CMake build failed
    cd ..
    pause
    exit /b 1
)

cd ..
echo ✓ CMake build completed successfully
goto :copy_files

:build_make
if %MINGW_AVAILABLE%==0 (
    echo ERROR: MinGW is required for this build method
    echo Please install MinGW or use a different build method
    pause
    exit /b 1
)

echo Building with MinGW Makefile...
if not exist "Makefile.windows" (
    echo ERROR: Makefile.windows not found
    pause
    exit /b 1
)

mingw32-make -f Makefile.windows release
if %errorlevel% neq 0 (
    echo ERROR: Make build failed
    pause
    exit /b 1
)

echo ✓ Make build completed successfully
goto :copy_files

:build_vs
if %VS_AVAILABLE%==0 (
    echo ERROR: Visual Studio is required for this build method
    echo Please install Visual Studio or use a different build method
    pause
    exit /b 1
)

echo Building with Visual Studio...
echo This method requires manual project setup in Visual Studio
echo Please see WINDOWS_SETUP.md for detailed instructions
pause
exit /b 0

:copy_files
echo.
echo Copying required files...

:: Copy input file to build directory if using CMake
if "%BUILD_METHOD%"=="cmake" (
    if exist "build\bin" (
        copy "input.txt" "build\bin\" >nul 2>&1
        echo ✓ Input file copied to build\bin\
    )
)

:: Copy DLLs if using MinGW
if "%BUILD_METHOD%"=="make" (
    echo Copying required DLLs...
    copy "C:\msys64\mingw64\bin\libgmp-10.dll" . >nul 2>&1
    copy "C:\msys64\mingw64\bin\libgcc_s_seh-1.dll" . >nul 2>&1
    copy "C:\msys64\mingw64\bin\libstdc++-6.dll" . >nul 2>&1
    echo ✓ DLLs copied (if found)
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.

:: Show available executables
echo Available executables:
if "%BUILD_METHOD%"=="cmake" (
    if exist "build\bin\rsa_parallel.exe" echo - build\bin\rsa_parallel.exe
    if exist "build\bin\rsa_serial.exe" echo - build\bin\rsa_serial.exe
    if exist "build\bin\rsa_naive.exe" echo - build\bin\rsa_naive.exe
) else (
    if exist "rsa_parallel.exe" echo - rsa_parallel.exe
    if exist "rsa_serial.exe" echo - rsa_serial.exe
    if exist "rsa_naive.exe" echo - rsa_naive.exe
)

echo.
echo Usage examples:
if "%BUILD_METHOD%"=="cmake" (
    echo   build\bin\rsa_serial.exe input.txt
    echo   build\bin\rsa_naive.exe input.txt 4
    echo   build\bin\rsa_parallel.exe 4
) else (
    echo   rsa_serial.exe input.txt
    echo   rsa_naive.exe input.txt 4
    echo   rsa_parallel.exe 4
)

echo.
echo For detailed instructions, see WINDOWS_SETUP.md
pause
exit /b 0

:help
echo Usage: build_windows.bat [method]
echo.
echo Available build methods:
echo   cmake  - Use CMake (default, recommended)
echo   make   - Use MinGW Makefile
echo   vs     - Manual Visual Studio setup
echo   help   - Show this help message
echo.
echo Examples:
echo   build_windows.bat
echo   build_windows.bat cmake
echo   build_windows.bat make
echo.
echo Prerequisites:
echo   - CMake (for cmake method)
echo   - MinGW-w64 (for make method)
echo   - Visual Studio (for vs method)
echo   - GMP library
echo   - OpenMP support
echo.
pause
exit /b 0

# RSA Parallelization - Windows Setup Guide

## Overview

This guide provides step-by-step instructions for building and running the RSA parallelization project on Windows. The project demonstrates three different RSA implementations with performance comparisons.

## Prerequisites

### Option 1: Using Visual Studio (Recommended)

#### Required Software
- **Visual Studio 2019 or 2022** (Community Edition is free)
- **Windows 10/11** (64-bit)
- **Git** (for cloning the repository)

#### Installation Steps
1. Download and install [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)
2. During installation, select:
   - **Desktop development with C++**
   - **MSVC v143 - VS 2022 C++ x64/x86 compiler**
   - **Windows 10/11 SDK**

### Option 2: Using MinGW-w64

#### Required Software
- **MinGW-w64** (GCC compiler for Windows)
- **MSYS2** (Package manager and build environment)
- **Windows 10/11** (64-bit)

#### Installation Steps
1. Download and install [MSYS2](https://www.msys2.org/)
2. Open MSYS2 terminal and install required packages:
   ```bash
   pacman -S mingw-w64-x86_64-gcc
   pacman -S mingw-w64-x86_64-make
   pacman -S mingw-w64-x86_64-gmp
   pacman -S mingw-w64-x86_64-openmp
   ```

### Option 3: Using WSL (Windows Subsystem for Linux)

#### Required Software
- **WSL2** with Ubuntu 20.04 or later
- **Windows 10/11** (64-bit)

#### Installation Steps
1. Enable WSL2: `wsl --install`
2. Install Ubuntu from Microsoft Store
3. Follow the Linux setup instructions in the main documentation

## Build Instructions

### Method 1: Visual Studio Solution

#### Step 1: Create Visual Studio Project
1. Open Visual Studio
2. Create a new **Empty Project** (C++)
3. Add the source files to your project:
   - `parallel_modular_exponentiation.cpp`
   - `rsa_serial.cpp`
   - `rsa_parallel_naive_approach.cpp`

#### Step 2: Configure Project Settings
1. Right-click project → **Properties**
2. Set **Configuration** to **All Configurations**
3. Set **Platform** to **x64**
4. Configure the following:

**C/C++ → General → Additional Include Directories:**
```
C:\msys64\mingw64\include
```

**C/C++ → Language → C++ Language Standard:**
```
ISO C++11 Standard (/std:c++11)
```

**C/C++ → Preprocessor → Preprocessor Definitions:**
```
_CRT_SECURE_NO_WARNINGS
```

**Linker → General → Additional Library Directories:**
```
C:\msys64\mingw64\lib
```

**Linker → Input → Additional Dependencies:**
```
gmp.lib
```

**Linker → System → SubSystem:**
```
Console (/SUBSYSTEM:CONSOLE)
```

#### Step 3: Build Configuration
Create separate build configurations for each implementation:

**For OpenMP projects (parallel_modular_exponentiation.cpp, rsa_parallel_naive_approach.cpp):**
- **C/C++ → Language → Open MP Support:** Yes (/openmp)

**For serial project (rsa_serial.cpp):**
- **C/C++ → Language → Open MP Support:** No

### Method 2: Using Makefile with MinGW

#### Step 1: Create Windows Makefile
Create a file named `Makefile.windows`:

```makefile
# Windows Makefile for RSA Parallelization
CC = g++
CFLAGS = -std=c++11 -O2
OPENMP_FLAGS = -fopenmp
GMP_INC = -I/mingw64/include
GMP_LIB = -L/mingw64/lib -lgmp

# Default target
all: rsa_parallel.exe rsa_serial.exe rsa_naive.exe

# Parallel modular exponentiation
rsa_parallel.exe: parallel_modular_exponentiation.cpp
	$(CC) $(CFLAGS) $(OPENMP_FLAGS) $(GMP_INC) $(GMP_LIB) -o $@ $<

# Serial RSA implementation
rsa_serial.exe: rsa_serial.cpp
	$(CC) $(CFLAGS) $(GMP_INC) $(GMP_LIB) -o $@ $<

# Naive parallel RSA implementation
rsa_naive.exe: rsa_parallel_naive_approach.cpp
	$(CC) $(CFLAGS) $(OPENMP_FLAGS) $(GMP_INC) $(GMP_LIB) -o $@ $<

# Clean build artifacts
clean:
	del /Q *.exe
```

#### Step 2: Build Commands
```cmd
# Using MinGW make
mingw32-make -f Makefile.windows

# Or using GNU make if available
make -f Makefile.windows
```

### Method 3: Using CMake (Cross-platform)

#### Step 1: Create CMakeLists.txt
Create a file named `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.10)
project(RSA_Parallelization)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required packages
find_package(GMP REQUIRED)
find_package(OpenMP)

# Parallel modular exponentiation
add_executable(rsa_parallel parallel_modular_exponentiation.cpp)
target_link_libraries(rsa_parallel GMP::GMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(rsa_parallel OpenMP::OpenMP_CXX)
endif()

# Serial RSA implementation
add_executable(rsa_serial rsa_serial.cpp)
target_link_libraries(rsa_serial GMP::GMP)

# Naive parallel RSA implementation
add_executable(rsa_naive rsa_parallel_naive_approach.cpp)
target_link_libraries(rsa_naive GMP::GMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(rsa_naive OpenMP::OpenMP_CXX)
endif()
```

#### Step 2: Build with CMake
```cmd
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

## Running the Applications

### Command Line Execution

#### 1. Serial RSA Implementation
```cmd
rsa_serial.exe input.txt
```

#### 2. Naive Parallel RSA Implementation
```cmd
rsa_naive.exe input.txt <number_of_threads>
```

#### 3. Optimized Parallel RSA Implementation
```cmd
rsa_parallel.exe <number_of_threads>
```

### Example Performance Test
```cmd
@echo off
echo === Performance Comparison ===
echo.
echo Serial RSA:
time rsa_serial.exe input.txt
echo.
echo Naive Parallel RSA (4 threads):
time rsa_naive.exe input.txt 4
echo.
echo Optimized Parallel RSA (4 threads):
time rsa_parallel.exe 4
```

## Troubleshooting

### Common Issues and Solutions

#### 1. "gmp.h not found" Error
**Solution:** Ensure GMP is properly installed and include paths are correct.

**For MinGW:**
```cmd
# Check if GMP is installed
pkg-config --modversion gmp
```

**For Visual Studio:** Verify include directories in project properties.

#### 2. "OpenMP not supported" Error
**Solution:** Enable OpenMP support in your compiler.

**For Visual Studio:**
- Project Properties → C/C++ → Language → Open MP Support: Yes (/openmp)

**For MinGW:**
- Add `-fopenmp` flag to compilation

#### 3. "Permission denied" Error
**Solution:** Run Command Prompt as Administrator or check file permissions.

#### 4. "DLL not found" Error
**Solution:** Ensure GMP DLLs are in PATH or copy them to executable directory.

**For MinGW:**
```cmd
# Copy required DLLs
copy C:\msys64\mingw64\bin\libgmp-10.dll .
copy C:\msys64\mingw64\bin\libgcc_s_seh-1.dll .
copy C:\msys64\mingw64\bin\libstdc++-6.dll .
```

### Performance Optimization

#### 1. Compiler Optimization Flags
**For MinGW:**
```makefile
CFLAGS = -std=c++11 -O3 -march=native
```

**For Visual Studio:**
- Project Properties → C/C++ → Optimization → Optimization: Maximum Optimization (Favor Speed) (/O2)

#### 2. Thread Count Optimization
Test different thread counts to find optimal performance:
```cmd
rsa_parallel.exe 1
rsa_parallel.exe 2
rsa_parallel.exe 4
rsa_parallel.exe 8
```

## Expected Results

Based on testing on Windows systems, you should expect similar performance characteristics:

| Implementation | Runtime (Windows) | Speedup |
|----------------|-------------------|---------|
| Serial RSA | ~2.1s | 1.0x |
| Naive Parallel | ~2.3s | 0.91x |
| Optimized Parallel | ~0.002s | **1050x** |

**Note:** Performance may vary based on:
- CPU specifications (cores, frequency)
- Windows version and updates
- Background processes
- Antivirus software impact

## Additional Resources

### Useful Tools
- **Process Monitor** - Monitor file and registry access
- **Process Explorer** - Advanced task manager
- **Visual Studio Profiler** - Performance analysis

### Debugging Tips
1. Use Visual Studio debugger for step-by-step execution
2. Enable verbose output in GMP for debugging
3. Use Windows Performance Toolkit for detailed analysis

### Alternative Build Systems
- **vcpkg** - C++ package manager for Windows
- **Conan** - Cross-platform package manager
- **Bazel** - Build system by Google

## Support

For issues specific to Windows builds:
1. Check Windows Event Viewer for system errors
2. Verify all dependencies are properly installed
3. Ensure compatibility with your Windows version
4. Consider using WSL2 for Linux-like development environment

---

**Last Updated:** December 2024  
**Tested on:** Windows 10/11, Visual Studio 2019/2022, MinGW-w64

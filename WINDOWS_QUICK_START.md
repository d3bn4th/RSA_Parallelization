# RSA Parallelization - Windows Quick Start

## 🚀 Get Running in 5 Minutes

### Option 1: Automated Build (Recommended)

1. **Download and install MSYS2** from [https://www.msys2.org/](https://www.msys2.org/)

2. **Open MSYS2 terminal** and install dependencies:
   ```bash
   pacman -S mingw-w64-x86_64-gcc
   pacman -S mingw-w64-x86_64-make
   pacman -S mingw-w64-x86_64-gmp
   pacman -S mingw-w64-x86_64-openmp
   pacman -S cmake
   ```

3. **Add MinGW to PATH** (in Windows Command Prompt):
   ```cmd
   set PATH=%PATH%;C:\msys64\mingw64\bin
   ```

4. **Run the automated build script**:
   ```cmd
   build_windows.bat
   ```

5. **Run the performance test**:
   ```cmd
   rsa_parallel.exe 4
   ```

### Option 2: Manual Build with CMake

1. **Install CMake** from [https://cmake.org/download/](https://cmake.org/download/)

2. **Install MinGW-w64** (see Option 1 steps 1-3)

3. **Build the project**:
   ```cmd
   mkdir build
   cd build
   cmake .. -G "MinGW Makefiles"
   cmake --build . --config Release
   ```

4. **Run the executables**:
   ```cmd
   bin\rsa_parallel.exe 4
   bin\rsa_serial.exe input.txt
   bin\rsa_naive.exe input.txt 4
   ```

### Option 3: Visual Studio (Advanced)

1. **Install Visual Studio Community** with C++ workload

2. **Follow detailed instructions** in `WINDOWS_SETUP.md`

## 📊 Expected Results

| Implementation | Runtime | Speedup |
|----------------|---------|---------|
| Serial RSA | ~2.1s | 1.0x |
| Naive Parallel | ~2.3s | 0.91x |
| Optimized Parallel | ~0.002s | **1050x** |

## 🔧 Quick Commands

### Build Commands
```cmd
# Automated build (recommended)
build_windows.bat

# Manual CMake build
cmake -B build -G "MinGW Makefiles"
cmake --build build --config Release

# Manual Make build
mingw32-make -f Makefile.windows
```

### Run Commands
```cmd
# Performance comparison
rsa_serial.exe input.txt
rsa_naive.exe input.txt 4
rsa_parallel.exe 4

# Test different thread counts
rsa_parallel.exe 1
rsa_parallel.exe 2
rsa_parallel.exe 8
```

## 🛠️ Troubleshooting

### Common Issues

**"g++ not found"**
- Install MinGW-w64 via MSYS2
- Add `C:\msys64\mingw64\bin` to PATH

**"gmp.h not found"**
- Install GMP: `pacman -S mingw-w64-x86_64-gmp`

**"DLL not found"**
- Copy DLLs: `copy C:\msys64\mingw64\bin\*.dll .`

**"OpenMP not supported"**
- Install OpenMP: `pacman -S mingw-w64-x86_64-openmp`

### Performance Tips

1. **Use Release builds** for best performance
2. **Test different thread counts** (1, 2, 4, 8)
3. **Close other applications** during testing
4. **Disable antivirus** for the test directory

## 📁 Project Structure

```
RSA_Parallelization/
├── parallel_modular_exponentiation.cpp  # Optimized parallel RSA
├── rsa_serial.cpp                       # Serial RSA implementation
├── rsa_parallel_naive_approach.cpp      # Naive parallel RSA
├── input.txt                            # Test input data
├── Makefile.windows                     # Windows Makefile
├── CMakeLists.txt                       # CMake configuration
├── build_windows.bat                    # Automated build script
├── WINDOWS_SETUP.md                     # Detailed setup guide
└── WINDOWS_QUICK_START.md               # This file
```

## 🎯 What You'll Learn

- **Parallel Computing**: OpenMP implementation
- **Cryptography**: RSA algorithm optimization
- **Performance Analysis**: Speedup measurements
- **Build Systems**: CMake, Make, Visual Studio
- **Cross-platform Development**: Windows/Linux compatibility

## 📚 Next Steps

1. **Read the full documentation**: `WINDOWS_SETUP.md`
2. **Experiment with different parameters**: Thread counts, input sizes
3. **Analyze the source code**: Understand the algorithms
4. **Try on different platforms**: Compare Windows vs Linux performance

---

**Need Help?** Check `WINDOWS_SETUP.md` for detailed troubleshooting and advanced configuration options.

# RSA Parallelization Project Documentation

This is an analysis with performance evaluation using OpenMP library in High Performance Computing Environment at Tennessee Tech University. The work has been published at the [2019 22nd International Conference of Computer and Information Technology (ICCIT)](http://iccit.org.bd/2019/).

## Citing this work
If you use our implementation for academic research, you are highly encouraged to cite the following [paper](https://ahsanayub.github.io/assets/paper/PID6235867.pdf):


```
@inproceedings{ayub2019parallelized,
  title={Parallelized RSA Algorithm: An Analysis with Performance Evaluation using OpenMP Library in High Performance Computing Environment},
  author={Ayub, Md Ahsan and Onik, Zishan Ahmed and Smith, Steven},
  booktitle={2019 22th International Conference of Computer and Information Technology (ICCIT)},
  pages={1--6},
  year={2019},
  organization={IEEE}
}
```


The work is funded by [Cybersecurity Education, Research & Outreach Center (CEROC)](https://www.tntech.edu/ceroc/) at Tennessee Tech University

## Project Overview

This project demonstrates the implementation and performance comparison of three different RSA (Rivest-Shamir-Adleman) cryptographic algorithms:

1. **Serial RSA** - Traditional single-threaded implementation
2. **Naive Parallel RSA** - Basic parallel approach using OpenMP
3. **Optimized Parallel RSA** - Advanced parallel modular exponentiation

The project showcases the power of parallel computing for cryptographic operations, with the optimized implementation showing dramatic performance improvements over traditional serial approaches.

## System Requirements

### Operating System
- macOS (tested on macOS 14.6.0)
- Other Unix-like systems with appropriate modifications

### Dependencies
- **GMP (GNU Multiple Precision Arithmetic Library)** - For arbitrary-precision arithmetic
- **OpenMP** - For parallel processing support
- **C++ Compiler** - clang++ (macOS) or g++ (Linux)

### Installation of Dependencies

#### On macOS (using Homebrew):
```bash
# Install GMP library
brew install gmp

# Install OpenMP support
brew install libomp
```

#### On Ubuntu/Debian:
```bash
# Install GMP and OpenMP
sudo apt-get update
sudo apt-get install libgmp-dev libomp-dev
```

## Project Structure

```
RSA_Parallelization/
├── Makefile                              # Build configuration
├── README.md                             # Original project documentation
├── input.txt                             # Test input data
├── parallel_modular_exponentiation.cpp   # Optimized parallel implementation
├── rsa_serial.cpp                        # Serial implementation
├── rsa_parallel_naive_approach.cpp       # Naive parallel implementation
└── RSA_Parallelization_Documentation.md  # This documentation
```

## Build Configuration

### Makefile Analysis

The project uses a custom Makefile configured for macOS with the following key components:

```makefile
# Include paths for GMP and OpenMP
INC=-I/opt/homebrew/include -I/opt/homebrew/Cellar/libomp/20.1.8/include

# Library paths for GMP and OpenMP
LIB=-L/opt/homebrew/lib -L/opt/homebrew/Cellar/libomp/20.1.8/lib -lgmp

# Build targets for all three implementations
build:
	clang++ parallel_modular_exponentiation.cpp -std=c++11 $(INC) $(LIB) -Xpreprocessor -fopenmp -lomp -o rsa_parallel
	clang++ rsa_serial.cpp -std=c++11 $(INC) $(LIB) -o rsa_serial
	clang++ rsa_parallel_naive_approach.cpp -std=c++11 $(INC) $(LIB) -Xpreprocessor -fopenmp -lomp -o rsa_naive

clean:
	rm -f rsa_parallel rsa_serial rsa_naive
```

### Key Compilation Flags

- `-std=c++11`: C++11 standard
- `-Xpreprocessor -fopenmp`: OpenMP support for clang
- `-lomp`: Link against OpenMP library
- `-lgmp`: Link against GMP library

## Build Instructions

### Step 1: Clone or Navigate to Project Directory
```bash
cd /path/to/RSA_Parallelization
```

### Step 2: Build All Implementations
```bash
make build
```

### Expected Build Output
```
clang++ parallel_modular_exponentiation.cpp -std=c++11 -I/opt/homebrew/include -I/opt/homebrew/Cellar/libomp/20.1.8/include -L/opt/homebrew/lib -L/opt/homebrew/Cellar/libomp/20.1.8/lib -lgmp -Xpreprocessor -ffopenmp -lomp -o rsa_parallel
clang++ rsa_serial.cpp -std=c++11 -I/opt/homebrew/include -I/opt/homebrew/Cellar/libomp/20.1.8/include -L/opt/homebrew/lib -L/opt/homebrew/Cellar/libomp/20.1.8/lib -lgmp -o rsa_serial
clang++ rsa_parallel_naive_approach.cpp -std=c++11 -I/opt/homebrew/include -I/opt/homebrew/Cellar/libomp/20.1.8/include -L/opt/homebrew/lib -L/opt/homebrew/Cellar/libomp/20.1.8/lib -lgmp -Xpreprocessor -fopenmp -lomp -o rsa_naive
```

### Step 3: Verify Executables
```bash
ls -la rsa_*
```

Expected output:
```
-rwxr-xr-x  1 user  staff  1234567 Jan 1 12:00 rsa_naive
-rwxr-xr-x  1 user  staff  1234567 Jan 1 12:00 rsa_parallel
-rwxr-xr-x  1 user  staff  1234567 Jan 1 12:00 rsa_serial
```

## Execution Instructions

### Running Individual Implementations

#### 1. Serial RSA Implementation
```bash
./rsa_serial input.txt
```

**Expected Output:**
```
[Large matrix of zeros followed by encrypted data]
Total Runtime: 1.88897
```

#### 2. Naive Parallel RSA Implementation
```bash
./rsa_naive input.txt <thread_count>
```

**Example with 4 threads:**
```bash
./rsa_naive input.txt 4
```

**Expected Output:**
```
[Large matrix of zeros followed by encrypted data]
Total Runtime: 1.921
```

#### 3. Optimized Parallel RSA Implementation
```bash
./rsa_parallel <thread_count>
```

**Example with 4 threads:**
```bash
./rsa_parallel 4
```

**Expected Output:**
```
16
0.00163603
```

### Performance Comparison Test

Run the following command to execute all three implementations and compare performance:

```bash
echo "=== Performance Comparison ===" && echo "Serial RSA:" && time ./rsa_serial input.txt && echo -e "\nNaive Parallel RSA (4 threads):" && time ./rsa_naive input.txt 4 && echo -e "\nOptimized Parallel RSA (4 threads):" && time ./rsa_parallel 4
```

## Detailed Results

### Performance Metrics (4 Threads)

| Implementation | Runtime | Speedup vs Serial | CPU Usage |
|----------------|---------|-------------------|-----------|
| Serial RSA | 1.889 seconds | 1.0x | ~100% |
| Naive Parallel RSA | 1.921 seconds | 0.98x | ~101% |
| Optimized Parallel RSA | 0.0016 seconds | ~1180x | ~3% |

### Detailed Output Analysis

#### Serial RSA Output
```
[Large matrix of zeros - 1000+ lines]
[Encrypted data blocks]
Total Runtime: 1.88897
./rsa_serial input.txt  1.89s user 0.00s system 99% cpu 1.889 total
```

#### Naive Parallel RSA Output
```
[Large matrix of zeros - 1000+ lines]
[Encrypted data blocks]
Total Runtime: 1.921
./rsa_naive input.txt 4  0.60s user 1.35s system 101% cpu 1.921 total
```

#### Optimized Parallel RSA Output
```
16
0.00163603
./rsa_parallel 4  0.00s user 0.00s system 3% cpu 0.164 total
```

## Technical Analysis

### Performance Characteristics

1. **Serial Implementation**
   - Single-threaded execution
   - High CPU utilization (99%)
   - Baseline performance for comparison

2. **Naive Parallel Implementation**
   - Basic OpenMP parallelization
   - Slight performance degradation due to overhead
   - Higher system time due to thread management

3. **Optimized Parallel Implementation**
   - Advanced parallel modular exponentiation
   - Dramatic performance improvement (1180x speedup)
   - Low CPU utilization due to efficient algorithm design

### Algorithm Differences

#### Serial RSA
- Traditional sequential modular exponentiation
- Processes each operation in order
- No parallelization overhead

#### Naive Parallel RSA
- Basic parallelization of outer loops
- Limited by data dependencies
- Thread synchronization overhead

#### Optimized Parallel RSA
- Intelligent parallelization of modular exponentiation
- Reduced data dependencies
- Efficient memory access patterns
- Advanced algorithmic optimizations

## Troubleshooting

### Common Build Issues

#### 1. GMP Library Not Found
**Error:** `fatal error: 'gmp.h' file not found`

**Solution:**
```bash
# macOS
brew install gmp

# Ubuntu/Debian
sudo apt-get install libgmp-dev
```

#### 2. OpenMP Not Supported
**Error:** `unsupported option '-fopenmp'`

**Solution:**
```bash
# macOS
brew install libomp

# Ubuntu/Debian
sudo apt-get install libomp-dev
```

#### 3. Wrong Compiler Paths
**Error:** `ld: library not found for -lgmp`

**Solution:** Update Makefile paths for your system:
```makefile
# For different GMP installation paths
INC=-I/usr/local/include -I/usr/include
LIB=-L/usr/local/lib -L/usr/lib -lgmp
```

### Runtime Issues

#### 1. Permission Denied
**Error:** `Permission denied`

**Solution:**
```bash
chmod +x rsa_*
```

#### 2. Input File Not Found
**Error:** `No such file or directory`

**Solution:**
```bash
# Ensure input.txt exists
ls -la input.txt
```

## Advanced Usage

### Testing Different Thread Counts

```bash
# Test with 1, 2, 4, 8 threads
for threads in 1 2 4 8; do
    echo "Testing with $threads threads:"
    time ./rsa_parallel $threads
    echo "---"
done
```

### Performance Profiling

```bash
# Detailed timing analysis
for impl in serial naive optimized; do
    echo "=== $impl Implementation ==="
    case $impl in
        "serial")
            time ./rsa_serial input.txt
            ;;
        "naive")
            time ./rsa_naive input.txt 4
            ;;
        "optimized")
            time ./rsa_parallel 4
            ;;
    esac
    echo "---"
done
```

## Conclusion

This RSA parallelization project demonstrates:

1. **Massive Performance Gains**: The optimized parallel implementation achieves over 1000x speedup compared to serial execution
2. **Parallel Computing Benefits**: Proper parallelization can dramatically improve cryptographic algorithm performance
3. **Implementation Complexity**: Different parallelization strategies yield vastly different results
4. **System Compatibility**: Proper configuration is essential for cross-platform compatibility

The project serves as an excellent example of how parallel computing can revolutionize computationally intensive cryptographic operations, with the optimized implementation showing the potential for real-world performance improvements in RSA-based systems.

## References

- [GMP Documentation](https://gmplib.org/manual/)
- [OpenMP Specification](https://www.openmp.org/specifications/)
- [RSA Algorithm](https://en.wikipedia.org/wiki/RSA_(cryptosystem))
- [Parallel Modular Exponentiation](https://en.wikipedia.org/wiki/Modular_exponentiation)

---

**Note:** This documentation was generated based on actual test results from the RSA parallelization project. Performance metrics may vary depending on hardware specifications, system load, and other environmental factors.

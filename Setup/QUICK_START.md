# RSA Parallelization - Quick Start Guide

## 🚀 Quick Replication Steps

### 1. Install Dependencies (macOS)
```bash
brew install gmp libomp
```

### 2. Build All Implementations
```bash
make build
```

### 3. Run Performance Comparison
```bash
echo "=== Performance Comparison ===" && echo "Serial RSA:" && time ./rsa_serial input.txt && echo -e "\nNaive Parallel RSA (4 threads):" && time ./rsa_naive input.txt 4 && echo -e "\nOptimized Parallel RSA (4 threads):" && time ./rsa_parallel 4
```

## 📊 Expected Results

| Implementation | Runtime | Speedup |
|----------------|---------|---------|
| Serial RSA | ~1.89s | 1.0x |
| Naive Parallel | ~1.92s | 0.98x |
| Optimized Parallel | ~0.0016s | **1180x** |

## 🔧 Individual Commands

### Serial RSA
```bash
./rsa_serial input.txt
```

### Naive Parallel RSA (4 threads)
```bash
./rsa_naive input.txt 4
```

### Optimized Parallel RSA (4 threads)
```bash
./rsa_parallel 4
```

## 🐛 Common Issues

### Build Errors
- **GMP not found**: `brew install gmp`
- **OpenMP not found**: `brew install libomp`
- **Permission denied**: `chmod +x rsa_*`

### Runtime Errors
- **Input file missing**: Ensure `input.txt` exists
- **Wrong thread count**: Use positive integers (1, 2, 4, 8, etc.)

## 📈 Performance Testing

### Test Different Thread Counts
```bash
for t in 1 2 4 8; do echo "Threads: $t"; time ./rsa_parallel $t; done
```

### Clean Build
```bash
make clean && make build
```

---

**Full Documentation**: See `RSA_Parallelization_Documentation.md` for detailed analysis and troubleshooting.

#!/bin/bash

# RSA Parallelization - macOS Build Script
# Usage: ./scripts/macos/build.sh [options]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BUILD_TYPE="release"
CLEAN_BUILD=false
RUN_TESTS=false
INSTALL_DEPS=false
HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            BUILD_TYPE="debug"
            shift
            ;;
        --release)
            BUILD_TYPE="release"
            shift
            ;;
        --profile)
            BUILD_TYPE="profile"
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --test)
            RUN_TESTS=true
            shift
            ;;
        --install-deps)
            INSTALL_DEPS=true
            shift
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Show help
if [ "$HELP" = true ]; then
    echo "RSA Parallelization - macOS Build Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --debug         Build with debug symbols"
    echo "  --release       Build with release optimization (default)"
    echo "  --profile       Build with profiling support"
    echo "  --clean         Clean build artifacts before building"
    echo "  --test          Run performance tests after building"
    echo "  --install-deps  Install system dependencies"
    echo "  --help, -h      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build release version"
    echo "  $0 --debug --test     # Build debug version and run tests"
    echo "  $0 --clean --release  # Clean and build release version"
    exit 0
fi

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the project root
if [ ! -f "src/parallel_modular_exponentiation.cpp" ]; then
    print_error "Source files not found!"
    print_error "Please run this script from the project root directory."
    exit 1
fi

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew not found. Please install Homebrew first:"
        print_error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
}

# Install dependencies using Homebrew
install_dependencies() {
    print_status "Installing dependencies using Homebrew..."
    brew install gmp libomp
    print_success "Dependencies installed"
}

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    # Check for clang++
    if ! command -v clang++ &> /dev/null; then
        print_error "clang++ not found. Please install Xcode Command Line Tools:"
        print_error "  xcode-select --install"
        return 1
    fi
    
    # Check for GMP
    if ! brew list gmp &> /dev/null; then
        print_error "GMP library not found. Please install with: brew install gmp"
        return 1
    fi
    
    # Check for OpenMP
    if ! brew list libomp &> /dev/null; then
        print_error "OpenMP not found. Please install with: brew install libomp"
        return 1
    fi
    
    print_success "All dependencies found"
    return 0
}

# Clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    make -f Makefile.macos clean
    print_success "Build artifacts cleaned"
}

# Build the project
build_project() {
    print_status "Building project with $BUILD_TYPE configuration..."
    
    case $BUILD_TYPE in
        debug)
            make -f Makefile.macos debug
            ;;
        release)
            make -f Makefile.macos release
            ;;
        profile)
            make -f Makefile.macos profile
            ;;
    esac
    
    print_success "Build completed successfully"
}

# Run tests
run_tests() {
    print_status "Running performance tests..."
    make -f Makefile.macos test
    print_success "Tests completed"
}

# Main execution
main() {
    echo "========================================"
    echo "RSA Parallelization - macOS Builder"
    echo "========================================"
    echo ""
    
    # Check Homebrew
    check_homebrew
    
    # Install dependencies if requested
    if [ "$INSTALL_DEPS" = true ]; then
        install_dependencies
    fi
    
    # Check dependencies
    if ! check_dependencies; then
        print_error "Dependency check failed"
        print_error "Run with --install-deps to install dependencies"
        exit 1
    fi
    
    # Clean build if requested
    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi
    
    # Build the project
    build_project
    
    # Run tests if requested
    if [ "$RUN_TESTS" = true ]; then
        run_tests
    fi
    
    echo ""
    echo "========================================"
    print_success "Build process completed successfully!"
    echo "========================================"
    echo ""
    
    # Show available executables
    echo "Available executables:"
    if [ -f "rsa_parallel" ]; then
        echo "  - rsa_parallel (Optimized Parallel RSA)"
    fi
    if [ -f "rsa_serial" ]; then
        echo "  - rsa_serial (Serial RSA)"
    fi
    if [ -f "rsa_naive" ]; then
        echo "  - rsa_naive (Naive Parallel RSA)"
    fi
    
    echo ""
    echo "Usage examples:"
    echo "  ./rsa_serial examples/input.txt"
    echo "  ./rsa_naive examples/input.txt 4"
    echo "  ./rsa_parallel 4"
    echo ""
    echo "For more options, run: make -f Makefile.macos help"
}

# Run main function
main "$@"

#!/bin/bash

# RSA Parallelization - Linux Build Script
# Usage: ./scripts/linux/build.sh [options]

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
    echo "RSA Parallelization - Linux Build Script"
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

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Install dependencies based on distribution
install_dependencies() {
    local distro=$(detect_distro)
    print_status "Detected distribution: $distro"
    
    case $distro in
        ubuntu|debian)
            print_status "Installing dependencies for Ubuntu/Debian..."
            sudo apt-get update
            sudo apt-get install -y build-essential libgmp-dev libomp-dev
            ;;
        centos|rhel|fedora)
            print_status "Installing dependencies for CentOS/RHEL/Fedora..."
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y gmp-devel libomp-devel
            ;;
        arch)
            print_status "Installing dependencies for Arch Linux..."
            sudo pacman -S --needed base-devel gmp libomp
            ;;
        *)
            print_warning "Unknown distribution: $distro"
            print_warning "Please install the following packages manually:"
            print_warning "  - build-essential (or equivalent)"
            print_warning "  - libgmp-dev (or gmp-devel)"
            print_warning "  - libomp-dev (or libomp-devel)"
            ;;
    esac
}

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    # Check for g++
    if ! command -v g++ &> /dev/null; then
        print_error "g++ not found. Please install build-essential or equivalent."
        return 1
    fi
    
    # Check for GMP
    if ! pkg-config --exists gmp; then
        print_error "GMP library not found. Please install libgmp-dev or equivalent."
        return 1
    fi
    
    # Check for OpenMP
    if ! g++ -fopenmp -E - < /dev/null &> /dev/null; then
        print_error "OpenMP not supported. Please install libomp-dev or equivalent."
        return 1
    fi
    
    print_success "All dependencies found"
    return 0
}

# Clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    make -f Makefile.linux clean
    print_success "Build artifacts cleaned"
}

# Build the project
build_project() {
    print_status "Building project with $BUILD_TYPE configuration..."
    
    case $BUILD_TYPE in
        debug)
            make -f Makefile.linux debug
            ;;
        release)
            make -f Makefile.linux release
            ;;
        profile)
            make -f Makefile.linux profile
            ;;
    esac
    
    print_success "Build completed successfully"
}

# Run tests
run_tests() {
    print_status "Running performance tests..."
    make -f Makefile.linux test
    print_success "Tests completed"
}

# Main execution
main() {
    echo "========================================"
    echo "RSA Parallelization - Linux Builder"
    echo "========================================"
    echo ""
    
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
    echo "For more options, run: make -f Makefile.linux help"
}

# Run main function
main "$@"

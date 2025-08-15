# Main Makefile for RSA Parallelization
# This file provides a unified interface for all platforms

# Detect platform
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Default target
all: detect-platform

# Platform detection and delegation
detect-platform:
	@echo "Detecting platform..."
ifeq ($(OS),Windows_NT)
	@echo "Windows detected - using Makefile.windows"
	@$(MAKE) -f Makefile.windows all
else ifeq ($(UNAME_S),Darwin)
	@echo "macOS detected - using Makefile.macos"
	@$(MAKE) -f Makefile.macos all
else ifeq ($(UNAME_S),Linux)
	@echo "Linux detected - using Makefile.linux"
	@$(MAKE) -f Makefile.linux all
else
	@echo "Unknown platform - trying Linux Makefile"
	@$(MAKE) -f Makefile.linux all
endif

# Delegate all targets to platform-specific Makefiles
%: detect-platform
ifeq ($(OS),Windows_NT)
	@$(MAKE) -f Makefile.windows $@
else ifeq ($(UNAME_S),Darwin)
	@$(MAKE) -f Makefile.macos $@
else ifeq ($(UNAME_S),Linux)
	@$(MAKE) -f Makefile.linux $@
else
	@$(MAKE) -f Makefile.linux $@
endif

# Help target
help:
	@echo "RSA Parallelization - Main Makefile"
	@echo ""
	@echo "This Makefile automatically detects your platform and delegates to the appropriate build system."
	@echo ""
	@echo "Available targets:"
	@echo "  all              - Build all executables"
	@echo "  debug            - Build with debug symbols"
	@echo "  release          - Build with maximum optimization"
	@echo "  clean            - Remove all executables and build artifacts"
	@echo "  test             - Run performance comparison test"
	@echo "  help             - Show this help message"
	@echo ""
	@echo "Platform-specific targets:"
	@echo "  install-deps     - Install system dependencies"
	@echo "  check-deps       - Check if dependencies are installed"
	@echo "  thread-scaling   - Test performance with different thread counts"
	@echo ""
	@echo "Examples:"
	@echo "  make all         # Build all implementations"
	@echo "  make test        # Run performance tests"
	@echo "  make clean       # Clean build artifacts"
	@echo "  make help        # Show detailed help"
cmake_minimum_required(VERSION 3.10)
project(RSA_Parallelization VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find required packages
find_package(GMP REQUIRED)
find_package(OpenMP)

# Print status messages
if(GMP_FOUND)
    message(STATUS "GMP found: ${GMP_INCLUDE_DIRS}")
else()
    message(FATAL_ERROR "GMP not found. Please install GMP library.")
endif()

if(OpenMP_CXX_FOUND)
    message(STATUS "OpenMP found: ${OpenMP_CXX_FLAGS}")
else()
    message(WARNING "OpenMP not found. Parallel implementations will not be built.")
endif()

# Parallel modular exponentiation
add_executable(rsa_parallel parallel_modular_exponentiation.cpp)
target_include_directories(rsa_parallel PRIVATE ${GMP_INCLUDE_DIRS})
target_link_libraries(rsa_parallel PRIVATE GMP::GMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(rsa_parallel PRIVATE OpenMP::OpenMP_CXX)
endif()

# Serial RSA implementation
add_executable(rsa_serial rsa_serial.cpp)
target_include_directories(rsa_serial PRIVATE ${GMP_INCLUDE_DIRS})
target_link_libraries(rsa_serial PRIVATE GMP::GMP)

# Naive parallel RSA implementation
add_executable(rsa_naive rsa_parallel_naive_approach.cpp)
target_include_directories(rsa_naive PRIVATE ${GMP_INCLUDE_DIRS})
target_link_libraries(rsa_naive PRIVATE GMP::GMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(rsa_naive PRIVATE OpenMP::OpenMP_CXX)
endif()

# Set compiler-specific flags
if(MSVC)
    # Visual Studio specific settings
    target_compile_definitions(rsa_parallel PRIVATE _CRT_SECURE_NO_WARNINGS)
    target_compile_definitions(rsa_serial PRIVATE _CRT_SECURE_NO_WARNINGS)
    target_compile_definitions(rsa_naive PRIVATE _CRT_SECURE_NO_WARNINGS)
    
    # Enable OpenMP for MSVC
    if(OpenMP_CXX_FOUND)
        set_target_properties(rsa_parallel PROPERTIES COMPILE_FLAGS "/openmp")
        set_target_properties(rsa_naive PROPERTIES COMPILE_FLAGS "/openmp")
    endif()
else()
    # GCC/Clang specific settings
    target_compile_options(rsa_parallel PRIVATE -Wall -Wextra)
    target_compile_options(rsa_serial PRIVATE -Wall -Wextra)
    target_compile_options(rsa_naive PRIVATE -Wall -Wextra)
endif()

# Add custom targets for convenience
add_custom_target(build-all
    DEPENDS rsa_parallel rsa_serial rsa_naive
    COMMENT "Building all RSA implementations"
)

# Performance test target
if(WIN32)
    add_custom_target(test-performance
        COMMAND ${CMAKE_COMMAND} -E echo "=== Performance Comparison ==="
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Serial RSA:"
        COMMAND ${CMAKE_COMMAND} -E env "time" $<TARGET_FILE:rsa_serial> input.txt
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Naive Parallel RSA (4 threads):"
        COMMAND ${CMAKE_COMMAND} -E env "time" $<TARGET_FILE:rsa_naive> input.txt 4
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Optimized Parallel RSA (4 threads):"
        COMMAND ${CMAKE_COMMAND} -E env "time" $<TARGET_FILE:rsa_parallel> 4
        DEPENDS build-all
        COMMENT "Running performance comparison tests"
    )
else()
    add_custom_target(test-performance
        COMMAND ${CMAKE_COMMAND} -E echo "=== Performance Comparison ==="
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Serial RSA:"
        COMMAND time $<TARGET_FILE:rsa_serial> input.txt
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Naive Parallel RSA (4 threads):"
        COMMAND time $<TARGET_FILE:rsa_naive> input.txt 4
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "Optimized Parallel RSA (4 threads):"
        COMMAND time $<TARGET_FILE:rsa_parallel> 4
        DEPENDS build-all
        COMMENT "Running performance comparison tests"
    )
endif()

# Install targets
install(TARGETS rsa_parallel rsa_serial rsa_naive
    RUNTIME DESTINATION bin
)

# Install input file
install(FILES input.txt
    DESTINATION bin
)

# Print configuration summary
message(STATUS "")
message(STATUS "=== RSA Parallelization Configuration ===")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "GMP: ${GMP_VERSION}")
message(STATUS "OpenMP: ${OpenMP_CXX_FOUND}")
message(STATUS "Platform: ${CMAKE_SYSTEM_NAME}")
message(STATUS "==========================================")
message(STATUS "")

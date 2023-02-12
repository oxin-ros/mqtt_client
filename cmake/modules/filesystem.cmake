# MIT License

# Copyright (c) 2021 Zachary Ferguson and the IPC Simulation organization

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Adapted from https://github.com/ipc-sim/rigid-ipc/blob/main/cmake/recipes/filesystem.cmake.

if(TARGET ghc::filesystem)
    return()
endif()

message(STATUS "Third-party: creating target 'ghc::filesystem'")

include(FetchContent)
FetchContent_Declare(
    filesystem
    GIT_REPOSITORY https://github.com/gulrak/filesystem.git
    GIT_TAG v1.5.12
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(filesystem)
add_library(ghc::filesystem ALIAS ghc_filesystem)

# Check if we need to link against any special libraries (e.g., stdc++fs for GCC < 9)
set(SAVED_CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES})
set(SAVED_CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES})

set(GHC_FILESYSTEM_TEST_CODE [[
        #include <ghc/fs_std.hpp>
        int main() {
            auto cwd = fs::current_path();
            return static_cast<int>(cwd.string().size());
        }
    ]])


# Try to compile a simple filesystem program without any linker flags
INCLUDE(CheckCXXSourceCompiles)
list(APPEND CMAKE_REQUIRED_INCLUDES "${filesystem_SOURCE_DIR}/include")
check_cxx_source_compiles("${GHC_FILESYSTEM_TEST_CODE}" GHC_FILESYSTEM_NO_LINK_NEEDED)

if(NOT GHC_FILESYSTEM_NO_LINK_NEEDED)
    # Add the libstdc++ flag
    set(CMAKE_REQUIRED_LIBRARIES ${SAVED_CMAKE_REQUIRED_LIBRARIES} -lstdc++fs)
    check_cxx_source_compiles("${GHC_FILESYSTEM_TEST_CODE}" GHC_FILESYSTEM_STDCPPFS_NEEDED)

    if(NOT GHC_FILESYSTEM_STDCPPFS_NEEDED)
        # Try the libc++ flag
        set(CMAKE_REQUIRED_LIBRARIES ${SAVED_CMAKE_REQUIRED_LIBRARIES} -lc++fs)
        check_cxx_source_compiles("${GHC_FILESYSTEM_TEST_CODE}" GHC_FILESYSTEM_CPPFS_NEEDED)
    endif()
endif()

# NOTE: `target_link_libraries` requires CMake 3.13 and above to avoid a warning about Policy CMP0079.
if(GHC_FILESYSTEM_NO_LINK_NEEDED)
    # on certain linux distros we have a version of libstdc++ which has the final code for c++17 fs in the
    # libstdc++.so.*. BUT when compiling with g++ < 9, we MUST still link with libstdc++fs.a
    # libc++ should not suffer from this issue, so, in theory we should be fine with only checking for
    # GCC's libstdc++
    if((CMAKE_CXX_COMPILER_ID MATCHES "GNU") AND (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0"))
        target_link_libraries(ghc_filesystem INTERFACE -lstdc++fs)
    endif()
elseif(GHC_FILESYSTEM_STDCPPFS_NEEDED)
    target_link_libraries(ghc_filesystem INTERFACE -lstdc++fs)
elseif(GHC_FILESYSTEM_CPPFS_NEEDED)
    target_link_libraries(ghc_filesystem INTERFACE -lc++fs)
else()
    message(FATAL_ERROR "Unable to determine correct linking options to compile GHC filesystem!")
endif()

set(CMAKE_REQUIRED_INCLUDES ${SAVED_CMAKE_REQUIRED_INCLUDES})
set(CMAKE_REQUIRED_LIBRARIES ${SAVED_CMAKE_REQUIRED_LIBRARIES})
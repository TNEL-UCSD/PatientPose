# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.0

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/kjchen/anaconda2/bin/cmake

# The command to remove a file.
RM = /home/kjchen/anaconda2/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build

# Include any dependencies generated for this target.
include tools/CMakeFiles/net_speed_benchmark.dir/depend.make

# Include the progress variables for this target.
include tools/CMakeFiles/net_speed_benchmark.dir/progress.make

# Include the compile flags for this target's objects.
include tools/CMakeFiles/net_speed_benchmark.dir/flags.make

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o: tools/CMakeFiles/net_speed_benchmark.dir/flags.make
tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o: ../tools/net_speed_benchmark.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o"
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools && /home/kjchen/anaconda2/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o -c /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/tools/net_speed_benchmark.cpp

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.i"
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools && /home/kjchen/anaconda2/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/tools/net_speed_benchmark.cpp > CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.i

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.s"
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools && /home/kjchen/anaconda2/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/tools/net_speed_benchmark.cpp -o CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.s

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.requires:
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.requires

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.provides: tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.requires
	$(MAKE) -f tools/CMakeFiles/net_speed_benchmark.dir/build.make tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.provides.build
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.provides

tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.provides.build: tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o

# Object files for target net_speed_benchmark
net_speed_benchmark_OBJECTS = \
"CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o"

# External object files for target net_speed_benchmark
net_speed_benchmark_EXTERNAL_OBJECTS =

tools/net_speed_benchmark: tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o
tools/net_speed_benchmark: tools/CMakeFiles/net_speed_benchmark.dir/build.make
tools/net_speed_benchmark: lib/libcaffe.so.1.0.0-rc3
tools/net_speed_benchmark: lib/libproto.a
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libboost_system.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libboost_thread.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libboost_filesystem.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libglog.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libgflags.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libprotobuf.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libglog.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libgflags.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libprotobuf.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libhdf5_hl.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libhdf5.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libhdf5_hl.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libhdf5.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/liblmdb.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libleveldb.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libsnappy.so
tools/net_speed_benchmark: /usr/local/cuda/lib64/libcudart.so
tools/net_speed_benchmark: /usr/local/cuda/lib64/libcurand.so
tools/net_speed_benchmark: /usr/local/cuda/lib64/libcublas.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libcudnn.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libopencv_highgui.so.2.4.11
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libopencv_imgproc.so.2.4.11
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libopencv_core.so.2.4.11
tools/net_speed_benchmark: /usr/lib/liblapack.so
tools/net_speed_benchmark: /usr/lib/libcblas.so
tools/net_speed_benchmark: /usr/lib/libatlas.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libpython2.7.so
tools/net_speed_benchmark: /home/kjchen/anaconda2/lib/libboost_python-mt.so
tools/net_speed_benchmark: tools/CMakeFiles/net_speed_benchmark.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable net_speed_benchmark"
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/net_speed_benchmark.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/CMakeFiles/net_speed_benchmark.dir/build: tools/net_speed_benchmark
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/build

tools/CMakeFiles/net_speed_benchmark.dir/requires: tools/CMakeFiles/net_speed_benchmark.dir/net_speed_benchmark.cpp.o.requires
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/requires

tools/CMakeFiles/net_speed_benchmark.dir/clean:
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools && $(CMAKE_COMMAND) -P CMakeFiles/net_speed_benchmark.dir/cmake_clean.cmake
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/clean

tools/CMakeFiles/net_speed_benchmark.dir/depend:
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/tools /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/tools/CMakeFiles/net_speed_benchmark.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/CMakeFiles/net_speed_benchmark.dir/depend


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

# Utility rule file for jekyll.

# Include the progress variables for this target.
include docs/CMakeFiles/jekyll.dir/progress.make

docs/CMakeFiles/jekyll:
	$(CMAKE_COMMAND) -E cmake_progress_report /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Launching jekyll..."
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/docs && jekyll serve -w -s . -d _site --port=4000

jekyll: docs/CMakeFiles/jekyll
jekyll: docs/CMakeFiles/jekyll.dir/build.make
.PHONY : jekyll

# Rule to build all files generated by this target.
docs/CMakeFiles/jekyll.dir/build: jekyll
.PHONY : docs/CMakeFiles/jekyll.dir/build

docs/CMakeFiles/jekyll.dir/clean:
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/docs && $(CMAKE_COMMAND) -P CMakeFiles/jekyll.dir/cmake_clean.cmake
.PHONY : docs/CMakeFiles/jekyll.dir/clean

docs/CMakeFiles/jekyll.dir/depend:
	cd /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/docs /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/docs /home/kjchen/Documents/TNEL_CV_Tracker/caffe-heatmap_cuDNN/build/docs/CMakeFiles/jekyll.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : docs/CMakeFiles/jekyll.dir/depend


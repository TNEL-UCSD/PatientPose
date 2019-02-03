# The set of languages for which implicit dependencies are needed:
set(CMAKE_DEPENDS_LANGUAGES
  )
# The set of files for implicit dependencies of each language:

# Preprocessor definitions for this target.
set(CMAKE_TARGET_DEFINITIONS
  "CAFFE_VERSION=1.0.0-rc3"
  "GTEST_USE_OWN_TR1_TUPLE"
  "USE_CUDNN"
  "USE_LEVELDB"
  "USE_LMDB"
  "USE_OPENCV"
  "WITH_PYTHON_LAYER"
  )

# Targets to which this target links.
set(CMAKE_TARGET_LINKED_INFO_FILES
  )

# The include file search paths:
set(CMAKE_C_TARGET_INCLUDE_PATH
  "../src"
  "include"
  "/home/kjchen/anaconda2/include"
  "/usr/local/cuda/include"
  "/home/kjchen/anaconda2/include/opencv"
  "/usr/include/atlas"
  "/home/kjchen/anaconda2/include/python2.7"
  "/home/kjchen/.local/lib/python2.7/site-packages/numpy/core/include"
  "../include"
  "."
  )
set(CMAKE_CXX_TARGET_INCLUDE_PATH ${CMAKE_C_TARGET_INCLUDE_PATH})
set(CMAKE_Fortran_TARGET_INCLUDE_PATH ${CMAKE_C_TARGET_INCLUDE_PATH})
set(CMAKE_ASM_TARGET_INCLUDE_PATH ${CMAKE_C_TARGET_INCLUDE_PATH})

#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "caffe" for configuration "Release"
set_property(TARGET caffe APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(caffe PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE "proto;proto;/home/kjchen/anaconda2/lib/libboost_system.so;/home/kjchen/anaconda2/lib/libboost_thread.so;/home/kjchen/anaconda2/lib/libboost_filesystem.so;-lpthread;/home/kjchen/anaconda2/lib/libglog.so;/home/kjchen/anaconda2/lib/libgflags.so;/home/kjchen/anaconda2/lib/libprotobuf.so;-lpthread;/home/kjchen/anaconda2/lib/libhdf5_hl.so;/home/kjchen/anaconda2/lib/libhdf5.so;/home/kjchen/anaconda2/lib/libhdf5_hl.so;/home/kjchen/anaconda2/lib/libhdf5.so;/home/kjchen/anaconda2/lib/liblmdb.so;/home/kjchen/anaconda2/lib/libleveldb.so;/home/kjchen/anaconda2/lib/libsnappy.so;/usr/local/cuda/lib64/libcudart.so;/usr/local/cuda/lib64/libcurand.so;/usr/local/cuda/lib64/libcublas.so;/home/kjchen/anaconda2/lib/libcudnn.so;opencv_core;opencv_highgui;opencv_imgproc;/usr/lib/liblapack.so;/usr/lib/libcblas.so;/usr/lib/libatlas.so;/home/kjchen/anaconda2/lib/libpython2.7.so;/home/kjchen/anaconda2/lib/libboost_python-mt.so"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libcaffe.so.1.0.0-rc3"
  IMPORTED_SONAME_RELEASE "libcaffe.so.1.0.0-rc3"
  )

list(APPEND _IMPORT_CHECK_TARGETS caffe )
list(APPEND _IMPORT_CHECK_FILES_FOR_caffe "${_IMPORT_PREFIX}/lib/libcaffe.so.1.0.0-rc3" )

# Import target "proto" for configuration "Release"
set_property(TARGET proto APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(proto PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libproto.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS proto )
list(APPEND _IMPORT_CHECK_FILES_FOR_proto "${_IMPORT_PREFIX}/lib/libproto.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")

  set(CMAKE_Fortran_FLAGS
      "${CMAKE_Fortran_FLAGS} -g -traceback -fp-model source -free -convert big_endian")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0")

elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(GNU)$")

  set(CMAKE_Fortran_FLAGS
      "${CMAKE_Fortran_FLAGS} -g -fbacktrace -ffree-form -ffree-line-length-none -fconvert=big-endian")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -ggdb -fno-unsafe-math-optimizations -frounding-math -fsignaling-nans -ffpe-trap=invalid,zero,overflow -fbounds-check")

endif()

list(APPEND EXE_SRC
    ASSIGNNEMSIOVAR.f
    GETNEMSNDSCATTER.f
    GFSPOSTSIG.F
    INITPOST.F
    INITPOST_GFS.f
    INITPOST_GFS_NEMS.f
    INITPOST_GFS_NEMS_MPIIO.f
    INITPOST_GFS_NETCDF.f
    INITPOST_GFS_NETCDF_PARA.f
    INITPOST_GFS_SIGIO.f
    INITPOST_NEMS.f
    INITPOST_NEMS_MPIIO.f
    INITPOST_NETCDF.f
    INITPOST_NMM.f
    TIMEF.f
    WRFPOST.f
    getIVariableN.f
    getVariable.f
    getlvls.f
    intio_tags.f
    wrf_io_flags.f
    wrf_io_flags.h)

# Use IO stubs in place of WRFLIB
if(NOT wrf_FOUND)
  list(APPEND EXE_SRC
    io_int_stubs.f)
endif()

set(EXENAME "upp.x")

add_executable(${EXENAME} ${EXE_SRC})
add_dependencies(${EXENAME} ${PROJECT_NAME}::upp)
target_link_libraries(${EXENAME} PRIVATE
  upp::upp
  gfsio::gfsio
  nemsio::nemsio
  sfcio::sfcio
  sigio::sigio)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(${EXENAME} PUBLIC OpenMP::OpenMP_Fortran)
endif()

install(TARGETS ${EXENAME} RUNTIME DESTINATION bin)

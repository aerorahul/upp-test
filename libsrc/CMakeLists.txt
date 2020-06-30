list(APPEND LIB_SRC
    AllGETHERV_GSD.f
    ALLOCATE_ALL.f
    AVIATION.f
    BNDLYR.f
    BOUND.f
    CALCAPE.f
    CALCAPE2.f
    CALDRG.f
    CALDWP.f
    CALGUST.f
    CALHEL.f
    CALHEL2.f
    CALLCL.f
    CALMCVG.f
    CALMICT.f
    CALPBL.f
    CALPBLREGIME.f
    CALPOT.f
    CALPW.f
    CALRAD_WCLOUD_newcrtm.f
    CALRCH.f
    CALRH.f
    CALRH_GFS.f
    CALRH_GSD.f
    CALRH_PW.f
    CALSTRM.f
    CALTAU.f
    CALTHTE.f
    CALUPDHEL.f
    CALVESSEL.f
    CALVIS.f
    CALVIS_GSD.f
    CALVOR.f
    CALWXT_BOURG.f
    CALWXT_DOMINANT.f
    CALWXT_EXPLICIT.f
    CALWXT.f
    CALWXT_RAMER.f
    CALWXT_REVISED.f
    CANRES.f
    CLDFRAC_ZHAO.f
    CLDRAD.f
    CLMAX.f
    CMASSI.f
    COLLECT.f
    COLLECT_LOC.f
    CTLBLK.f
    cuparm.f
    DEALLOCATE.f
    DEWPOINT.f
    ETCALC.f
    ETAMP_Q2F.f
    EXCH2.f
    EXCH.f
    FDLVL.f
    FGAMMA.f
    FILL_PSETFLD.f
    FIXED.f
    FRZLVL2.f
    FRZLVL.f
    GEO_ZENITH_ANGLE.f
    GET_BITS.f
    GETGBANDSCATTER.f
    get_postfilename.f
    GFIP3.f
    GFSPOST.F
    GPVS.f
    grib2_module.f
    GRIBIT.F
    GRIDAVG.f
    GRIDSPEC.f
    gtg_algo.f90
    gtg_compute.f90
    gtg_config.f90
    gtg_ctlblk.f90
    gtg_filter.f90
    gtg_indices.f90
    gtg_smoothseams.f90
    ICAOHEIGHT.f
    kinds_mod.F
    LFMFLD.f
    LFMFLD_GFS.f
    LOOKUP.f
    machine.f
    map_routines.f90
    MAPSSLP.f
    MASKS_mod.f
    MDL2AGL.f
    MDL2P.f
    MDL2SIGMA2.f
    MDL2SIGMA.f
    MDL2STD_P.f
    MDL2THANDPV.f
    MDLFLD.f
    MICROINIT.F
    MISCLN.f
    MIXLEN.f
    MPI_FIRST.f
    MPI_LAST.f
    MSFPS.f
    native_endianness.f
    NGMFLD.f
    NGMSLP.f
    OTLFT.f
    OTLIFT.f
    PARAMR.f
    params.F
    PARA_RANGE.f
    physcons.f
    PMICRPH.f
    POLEAVG.f
    PROCESS.f
    READCNTRL.F
    READ_xml.f
    retrieve_index.f
    RHGRD.f
    RQSTFLD.F
    SCLFLD.f
    SELECT_CHANNELS.f
    SERVER.f
    SET_LVLSXML.f
    SET_OUTFLDS.f
    SETUP_SERVERS.f
    SLP_new.f
    SLP_NMM.f
    SMOOTH.f
    SNFRAC.f
    SNFRAC_GFS.f
    SOIL_mod.f
    SPLINE.f
    SURFCE.f
    svptbl.f
    TABLE.f
    TABLEQ.f
    TRPAUS.f
    TTBLEX.f
    VRBLS2D_mod.f
    VRBLS3D_mod.f
    VRBLS4D_mod.f
    WETBULB.f
    WETFRZLVL.f
    xml_perl_data.f
    ZENSUN.f)

set(LIBNAME "upp")

set(module_dir "${CMAKE_CURRENT_BINARY_DIR}/include")

add_library(${LIBNAME} STATIC ${LIB_SRC})
add_library(${PROJECT_NAME}::${LIBNAME} ALIAS ${LIBNAME})

set_target_properties(${LIBNAME} PROPERTIES Fortran_MODULE_DIRECTORY
                                            ${module_dir})

target_include_directories(${LIBNAME} INTERFACE
  $<BUILD_INTERFACE:${module_dir}>
  $<INSTALL_INTERFACE:include>)

target_link_libraries(${LIBNAME} PUBLIC
  bacio::bacio_4
  crtm::crtm
  g2::g2_4
  g2tmpl::g2tmpl
  ip::ip_4
  MPI::MPI_Fortran
  NetCDF::NetCDF_Fortran)

target_link_libraries(${LIBNAME} PRIVATE
  sp::sp_4
  w3emc::w3emc_4
  w3nco::w3nco_4)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(${LIBNAME} PUBLIC OpenMP::OpenMP_Fortran)
endif()

install(DIRECTORY ${module_dir} DESTINATION ${CMAKE_INSTALL_PREFIX})

install(
  TARGETS ${LIBNAME}
  EXPORT ${PROJECT_NAME}Exports
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)

### Package config
include(CMakePackageConfigHelpers)
set(CONFIG_INSTALL_DESTINATION lib/cmake/${PROJECT_NAME})

export(EXPORT ${PROJECT_NAME}Exports
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}-targets.cmake)

configure_package_config_file(
  ${CMAKE_SOURCE_DIR}/cmake/PackageConfig.cmake.in ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config.cmake
  INSTALL_DESTINATION ${CONFIG_INSTALL_DESTINATION})
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

write_basic_package_version_file(
  ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

install(EXPORT ${PROJECT_NAME}Exports
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}-targets.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

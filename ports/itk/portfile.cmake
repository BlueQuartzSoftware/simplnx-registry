vcpkg_buildpath_length_warning(37)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO InsightSoftwareConsortium/ITK
  REF "v${VERSION}"
  SHA512 225de9963e8eaf93ac32ca4a75c4e7aa887c8e926483c5aca0a4c77ef0e6cc6db4561f96a9ec3b936524ea698702705e8dc2c4a2e6a155733a12c0b3098ae11c
  HEAD_REF master
)

vcpkg_find_acquire_program(GIT)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  DISABLE_PARALLEL_CONFIGURE
  OPTIONS
    -DGIT_EXECUTABLE=${GIT}
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_PKGCONFIG_FILES:BOOL=OFF
    -DITK_DOXYGEN_HTML:BOOL=OFF
    -DDO_NOT_INSTALL_ITK_TEST_DRIVER:BOOL=ON
    -DITK_SKIP_PATH_LENGTH_CHECKS:BOOL=ON
    -DITK_INSTALL_DATA_DIR:PATH=share/itk/data
    -DITK_INSTALL_DOC_DIR:PATH=share/itk/doc
    -DITK_INSTALL_PACKAGE_DIR:PATH=share/itk

    -DBUILD_DOCUMENTATION:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DITK_USE_SYSTEM_EIGEN:BOOL=ON
    -DITK_USE_SYSTEM_HDF5:BOOL=ON
    -DITKV4_COMPATIBILITY:BOOL=ON
    -DITK_LEGACY_REMOVE:BOOL=OFF
    -DITK_FUTURE_LEGACY_REMOVE:BOOL=ON
    -DITK_LEGACY_SILENT:BOOL=OFF
    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF
    -DITKGroup_Core:BOOL=ON
    -DITKGroup_Filtering:BOOL=ON
    -DITKGroup_Registration:BOOL=ON
    -DITKGroup_Segmentation:BOOL=ON
    -DModule_ITKIOMRC:BOOL=ON
    -DModule_ITKReview:BOOL=ON
    -DModule_ITKMetricsv4:BOOL=ON
    -DModule_ITKOptimizersv4:BOOL=ON
    -DModule_ITKRegistrationMethodsv4:BOOL=ON
    -DModule_ITKIOTransformBase:BOOL=ON
    -DModule_ITKConvolution:BOOL=ON
    -DModule_ITKDenoising:BOOL=ON
    -DModule_ITKImageNoise:BOOL=ON

    # Disabled these modules for the moment due to FetchContent dependency
    # Additionally TotalVariation depends on proxtv which incorrectly lists some optional dependencies as required when installed

    # -DModule_Montage:BOOL=ON
    # -DModule_Montage_GIT_TAG:STRING=v0.7.3
    # -DModule_TotalVariation:BOOL=ON
    # -DModule_TotalVariation_GIT_TAG:STRING=v0.2.1
  OPTIONS_DEBUG
    -DCMAKE_DEBUG_POSTFIX:STRING=_d
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup()

# vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/Modules/TotalVariation.cmake" "set(Eigen3_DIR \"\${_IMPORT_PREFIX}/share/eigen3\")" "set(Eigen3_DIR \"\${ITK_INSTALL_PREFIX}/share/eigen3\")")
# vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/Modules/TotalVariation.cmake" "set(proxTV_DIR \"${CURRENT_PACKAGES_DIR}/share/itk/Modules\")" "set(proxTV_DIR \"\${ITK_INSTALL_PREFIX}/share/itk/Modules\")")

# set(IMPORT_PREFIX_LINE "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)")
# vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/Modules/proxTVTargets.cmake" "get_filename_component(_IMPORT_PREFIX \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)\n${IMPORT_PREFIX_LINE}\n${IMPORT_PREFIX_LINE}" "get_filename_component(_IMPORT_PREFIX \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)\n${IMPORT_PREFIX_LINE}\n${IMPORT_PREFIX_LINE}\n${IMPORT_PREFIX_LINE}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(REMOVE "${CURRENT_PACKAGES_DIR}/lib/zlib.pc")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/lib/zlib.pc")

string(REGEX MATCH "([0-9]+\\.[0-9]+)\\.[0-9]+" MATCH_OUTPUT "${VERSION}")
set(ITK_INCLUDE_DIR "${CURRENT_PACKAGES_DIR}/include/ITK-${CMAKE_MATCH_1}")

file(REMOVE "${ITK_INCLUDE_DIR}/vcl_where_root_dir.h")

vcpkg_replace_string("${ITK_INCLUDE_DIR}/gdcmConfigure.h" "#define GDCM_SOURCE_DIR \"${CURRENT_BUILDTREES_DIR}[^\r\n]*\"" "" REGEX)
vcpkg_replace_string("${ITK_INCLUDE_DIR}/gdcmConfigure.h" "#define GDCM_EXECUTABLE_OUTPUT_PATH.*\"${CURRENT_BUILDTREES_DIR}[^\r\n]*\"" "" REGEX)
vcpkg_replace_string("${ITK_INCLUDE_DIR}/gdcmConfigure.h" "#define GDCM_LIBRARY_OUTPUT_PATH.*\"${CURRENT_BUILDTREES_DIR}[^\r\n]*\"" "" REGEX)
vcpkg_replace_string("${ITK_INCLUDE_DIR}/gdcmConfigure.h" "#define GDCM_CMAKE_INSTALL_PREFIX \"${CURRENT_PACKAGES_DIR}[^\r\n]*\"" "" REGEX)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bluequartzsoftware/ebsdlib
  REF "v${VERSION}"
  SHA512 4745fe8879d7b432f978a0c310068e233299557ff7ff8954b8452d5c007c61df66a5cb6dc6a2c8bb76e46c4a1ae7b3961e5755d4097b9ad7c8ac8ef8800dc8a7
  HEAD_REF develop
)

set(EBSDLIB_COMMIT_HASH "d14bf1abcddc01f158ae55848695471fcac2b809")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    hdf5      EbsdLib_ENABLE_HDF5
    parallel  EbsdLib_USE_PARALLEL_ALGORITHMS
)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DDREAM3D_ANACONDA=ON
    -DCMP_TBB_ENABLE_COPY_INSTALL=OFF
    -DEbsdLib_ENABLE_TESTING=OFF
    -DEbsdLib_BUILD_TOOLS=OFF
    -DEbsdLib_BUILD_H5SUPPORT=OFF
    -DEbsdLib_CMAKE_CONFIG_INSTALL_DIR=share/${PORT}
    -DTBB_STATUS_PRINTED=ON
    -DGVS_GIT_HASH=${EBSDLIB_COMMIT_HASH}
    ${FEATURE_OPTIONS}
  MAYBE_UNUSED_VARIABLES
    CMP_TBB_ENABLE_COPY_INSTALL
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

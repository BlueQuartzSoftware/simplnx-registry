vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bluequartzsoftware/ebsdlib
  REF v1.0.27
  SHA512 a853d38d94dbea4f1502818e5a543adc8c1cfee7096fa69cbb2e7296c013236100128753bf66980e8c8e4a751283c6e03368a2e57575428fa8645a34e3cf9b40
  HEAD_REF develop
)

set(EBSDLIB_COMMIT_HASH "6c0e5ec992472eeae5df9d627de524b59b971fab")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    hdf5      EbsdLib_ENABLE_HDF5
    parallel  EbsdLib_USE_PARALLEL_ALGORITHMS
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
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

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bluequartzsoftware/ebsdlib
  REF v1.0.20
  SHA512 7a6fc146682fc2570c8a138b4c53c3143f746d1e94b52062831b06cbe30ade714fb25770dc532d6e3f00593f2ae1ff3a174ed4ab29a26c7960e09922e01f6fd1
  HEAD_REF develop
)

set(EBSDLIB_COMMIT_HASH "6c0e5ec992472eeae5df9d627de524b59b971fab")

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS
    -DDREAM3D_ANACONDA=ON
    -DCMP_TBB_ENABLE_COPY_INSTALL=OFF
    -DEbsdLib_ENABLE_TESTING=OFF
    -DEbsdLib_BUILD_TOOLS=OFF
    -DEbsdLib_ENABLE_HDF5=ON
    -DEbsdLib_BUILD_H5SUPPORT=OFF
    -DEbsdLib_CMAKE_CONFIG_INSTALL_DIR=share/${PORT}
    -DTBB_STATUS_PRINTED=ON
    -DGVS_GIT_HASH=${EBSDLIB_COMMIT_HASH}
  MAYBE_UNUSED_VARIABLES
    CMP_TBB_ENABLE_COPY_INSTALL
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

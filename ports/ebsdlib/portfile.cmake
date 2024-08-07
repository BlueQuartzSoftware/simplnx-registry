vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bluequartzsoftware/ebsdlib
  REF "v${VERSION}"
  SHA512 82c7fe8d011ee3d70936098442a3245973e463c281c673d309f52139053502bd8e9692f54da6684bf2bb498e4189556352975aa473a3f0328dc370645d5720e7
  HEAD_REF develop
)

set(EBSDLIB_COMMIT_HASH "d7db8a3a5f11b97ca56b9864de710f552d9dccf4")

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

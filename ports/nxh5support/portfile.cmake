vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bluequartzsoftware/nxh5support
  REF v0.1.0
  SHA512 3185dbd774086a206a5ab50e81ede604ba032d1d55b36dd4b98aea351f324f670d0db6bfea8995182bab20cd905eff6a81e9f24bf703d496ad714541fb0e55b2
  HEAD_REF develop
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS
  -DNXCOMMON_ENABLE_MULTICORE=ON
  -DNXH5SUPPORT_BUILD_TESTS=OFF
  -DNXCOMMON_BUILD_PYTHON=OFF
  -DNXH5SUPPORT_INSTALL_CMAKE_PREFIX=share/${PORT}
  -DNXCOMMON_BUILD_DOCS=OFF
  MAYBE_UNUSED_VARIABLES
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()
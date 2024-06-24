vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO fr00b0/nod
  REF "v${VERSION}"
  SHA512 e44c2f6e7e6f435be48936c3faa9dbc7cdbd115a2e08fb415060e7bb098c6cff35afd10c3e940a36214493117941dc822c09c6fd8055ff3c00f5b2265d1e6cbf
  HEAD_REF master
)

configure_file("${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt.in" "${SOURCE_PATH}/CMakeLists.txt" @ONLY)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/debug"
  "${CURRENT_PACKAGES_DIR}/lib"
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

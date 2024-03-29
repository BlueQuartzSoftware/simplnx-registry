# Automatically generated by scripts/boost/generate-ports.ps1

set(MP11_VERSION 1.77.0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mp11
    REF boost-${MP11_VERSION}
    SHA512 02a93db3c0ee65b6742109c369c70300465ebc7d824f4c9bbf8f083395e68f0a4d2b4def8299f2fc29bc5c7cb0b18dc5a4d96d1f0e20216a49986ce9387ca5d1
    HEAD_REF master
    PATCHES
        disable_fetchcontent.patch
)

# We manually clone boostorg/cmake and set boostorg_cmake_SOURCE_DIR because vcpkg now sets FETCHCONTENT_FULLY_DISCONNECTED. See https://github.com/microsoft/vcpkg/pull/26959
vcpkg_from_github(
    OUT_SOURCE_PATH BOOST_CMAKE_SOURCE_PATH
    REPO boostorg/cmake
    REF boost-${MP11_VERSION}
    SHA512 1b684655d9ffc8b48eb509248e933399c27e95f6f2657cdeb9542c5b3e56c9d2c377fa92e82d51d516cb37e2df77a002d5979886adfd627210c02337dff71216
    HEAD_REF master
)

vcpkg_find_acquire_program(GIT)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
        -DGIT_EXECUTABLE=${GIT}
        -Dboostorg_cmake_SOURCE_DIR=${BOOST_CMAKE_SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/boost_mp11-${MP11_VERSION} TARGET_PATH share/boost_mp11)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib)

vcpkg_download_distfile(ARCHIVE
    URLS "https://raw.githubusercontent.com/boostorg/boost/boost-${MP11_VERSION}/LICENSE_1_0.txt"
    FILENAME "boost_LICENSE_1_0.txt"
    SHA512 d6078467835dba8932314c1c1e945569a64b065474d7aced27c9a7acc391d52e9f234138ed9f1aa9cd576f25f12f557e0b733c14891d42c16ecdc4a7bd4d60b8
)

file(INSTALL ${ARCHIVE} DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

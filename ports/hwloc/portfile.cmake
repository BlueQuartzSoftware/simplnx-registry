vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO open-mpi/hwloc
    REF "hwloc-${VERSION}"
    SHA512 1ed47955d4a3ecf66636f1c5a89648ef055aa4f26fac9b9bc64d6f7715d671dc823337ebf38df53d60b50d697eccadfbd48d28b4540a5153c59d7eecd347f91c
    PATCHES
        fix_shared_win_build.patch
        stdout_fileno.patch
)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}/contrib/windows-cmake
        PREFER_NINJA
        OPTIONS
            -DBUILD_SHARED_LIBS=ON
            -DHWLOC_ENABLE_TESTING=OFF
    )

    vcpkg_install_cmake()

    file(READ ${CURRENT_PACKAGES_DIR}/include/hwloc/autogen/config.h PUBLIC_CONFIG_H)
    string(REPLACE "defined( DECLSPEC_EXPORTS )" "0" PUBLIC_CONFIG_H "${PUBLIC_CONFIG_H}")
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        string(REPLACE "defined( _USRDLL )" "0" PUBLIC_CONFIG_H "${PUBLIC_CONFIG_H}")
    else()
        string(REPLACE "defined( _USRDLL )" "1" PUBLIC_CONFIG_H "${PUBLIC_CONFIG_H}")
    endif()
    file(WRITE ${CURRENT_PACKAGES_DIR}/include/hwloc/autogen/config.h "${PUBLIC_CONFIG_H}")

    vcpkg_copy_tools(TOOL_NAMES
        hwloc-bind
        hwloc-calc
        hwloc-diff
        hwloc-distrib
        hwloc-gather-cpuid
        hwloc-info
        hwloc-patch
        lstopo
        lstopo-no-graphics
        lstopo-win
        AUTO_CLEAN
    )

    vcpkg_copy_pdbs()

    file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/tools)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

    # Handle copyright
    file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
else()
    if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
        set(OPTIONS ac_cv_prog_cc_c99= # To avoid the compiler check for C99 which will fail for MSVC
                    --disable-plugin-dlopen) 
    endif()

    if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        list(APPEND OPTIONS "HWLOC_LDFLAGS=-no-undefined")
    elseif(VCPKG_TARGET_IS_OSX)
        list(APPEND OPTIONS "HWLOC_LDFLAGS=-framework CoreFoundation")
    endif()

    vcpkg_configure_make(
        SOURCE_PATH "${SOURCE_PATH}"
        AUTOCONFIG
        OPTIONS
            ${OPTIONS} 
            --disable-libxml2
            --disable-opencl
            --disable-cairo
            --disable-cuda
            --disable-libudev
            --disable-levelzero
            --disable-nvml
            --disable-rsmi
            --disable-pci
            #--disable-cpuid
            #--disable-picky
    )

    vcpkg_install_make()
    vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")

    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-compress-dir")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-compress-dir" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../.." IGNORE_UNCHANGED)
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-compress-dir")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-compress-dir" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../.." IGNORE_UNCHANGED)
    endif()

    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-gather-topology")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/bin/hwloc-gather-topology" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../..")
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-gather-topology")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/hwloc/debug/bin/hwloc-gather-topology" "${CURRENT_INSTALLED_DIR}" "`dirname $0`/../../../..")
    endif()

    # Handle copyright
    file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

    file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/COPYING.txt"
                "${CURRENT_PACKAGES_DIR}/debug/README.txt"
                "${CURRENT_PACKAGES_DIR}/debug/NEWS.txt"
                "${CURRENT_PACKAGES_DIR}/COPYING.txt"
                "${CURRENT_PACKAGES_DIR}/README.txt"
                "${CURRENT_PACKAGES_DIR}/NEWS.txt"
        )
endif()

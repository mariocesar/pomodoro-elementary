project (pomodoro)

cmake_minimum_required (VERSION 2.8)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/pomodoro")
set (GETTEXT_PACKAGE "pomodoro")
set (RELEASE_NAME "Salsa Marinara.")
set (VERSION "0.1")
set (VERSION_INFO "Development")
set (EXEC_NAME "pomodoro")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite)

add_definitions(${DEPS_CFLAGS})

link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)

include(ValaVersion)
ensure_vala_version("0.22.0" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C
        src/Pomodoro.vala
        src/PomodoroWindow.vala
PACKAGES
        gtk+-3.0>=3.10
        posix
)

add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code -Wstrict-prototypes)
add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

project (pomodoro)
enable_testing ()

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/pomodoro")
set (APP_NAME "Pomodoro")
set (EXEC_NAME "pomodoro")
set (RELEASE_NAME "Salsa Marinara.")
set (VERSION "0.1")
set (VERSION_INFO "Develop")
set (CORE_LIBRARY_NAME lib${CMAKE_PROJECT_NAME})

find_package(PkgConfig)

set (PKG_DEPS
    gobject-2.0
    glib-2.0
    granite>=0.3.0
    gtk+-3.0
    libcanberra
    libnotify
)

set (VALA_DEPS
    gobject-2.0
    granite
    libcanberra
    libnotify
)

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version ("0.23.2" MINIMUM)
include(ValaPrecompile)

pkg_check_modules(DEPS REQUIRED ${PKG_DEPS})
set (CFLAGS ${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER})

add_definitions(${DEPS_CFLAGS})
link_directories(${DEPS_LIBRARY_DIRS})
link_libraries(${DEPS_LIBRARIES})

vala_precompile(VALA_C ${EXEC_NAME}
    src/Widgets/TimeDisplay.vala
    src/PomodoroTimer.vala
    src/PomodoroWindow.vala
    src/Pomodoro.vala
PACKAGES
    ${VALA_DEPS}
    posix
)

add_executable(${EXEC_NAME} ${VALA_C})
target_link_libraries (${EXEC_NAME} ${DEPS_LIBRARIES})

install(FILES ${_datafiles} DESTINATION ${PKGDATADIR}/style)
install(TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

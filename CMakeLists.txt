cmake_minimum_required(VERSION 3.16)

project(LegiForces VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick WebEngineQuick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appLegiForces
    main.cpp
)

qt_add_qml_module(appLegiForces
    URI LegiForces
    VERSION 1.0
    QML_FILES
        Main.qml
        components/LegiHeader.qml
        components/LegiFooter.qml
        components/LegiSidebar.qml
        components/LegiNavButton.qml
        components/LegiTooltip.qml
        components/LegiRightSidebar.qml
        components/LegiMainContent.qml
        components/LegiSocialButton.qml
        components/LegiNewsSidebar.qml
        pages/Dashboard.qml
        pages/Login.qml
        pages/CourtCases.qml
        pages/Users.qml
    RESOURCES
        DataDyneCorpLogo.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appLegiForces PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appLegiForces
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appLegiForces
    PRIVATE Qt6::Quick Qt6::WebEngineQuick
)

include(GNUInstallDirs)
install(TARGETS appLegiForces
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

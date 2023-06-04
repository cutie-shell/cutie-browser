cmake_minimum_required(VERSION 3.16)
project(cutie-browser VERSION 1.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml WebEngineQuick LinguistTools)

qt_standard_project_setup()

set(cutie-browser_SOURCES 
        src/main.cpp
)

qt_add_resources(APP_RESOURCES 
	${CMAKE_SOURCE_DIR}/src/qml/qml.qrc
	${CMAKE_SOURCE_DIR}/fonts/fonts.qrc)

qt_add_executable(cutie-browser ${cutie-browser_SOURCES} ${APP_RESOURCES})

target_include_directories(cutie-browser PUBLIC src)

target_link_libraries(cutie-browser PUBLIC Qt::Core Qt::Quick Qt::Qml Qt::WebEngineQuick)

install(TARGETS cutie-browser RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
install(FILES cutie-browser.desktop DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
install(FILES cutie-browser.svg DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps")

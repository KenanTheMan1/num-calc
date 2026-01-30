cmake_minimum_required(VERSION 3.16)
project(DigitApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appDigit
    main.cpp
    controller.cpp
    controller.h
)

qt_add_qml_module(appDigit
    URI DigitApp
    QML_FILES Main.qml
)

target_link_libraries(appDigit
    PRIVATE Qt6::Quick
)

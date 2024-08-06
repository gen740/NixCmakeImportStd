cmake_minimum_required(VERSION 3.29.20240416 FATAL_ERROR)

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")

project(import_std LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_MODULE_STD 1)

add_library(hello_world)
target_compile_features(
  hello_world
  PRIVATE cxx_std_23
  INTERFACE cxx_std_20)
target_sources(hello_world PUBLIC FILE_SET CXX_MODULES FILES hello_world.cc)

add_executable(main)
target_compile_features(
  main
  PRIVATE cxx_std_23
  INTERFACE cxx_std_20)
target_sources(main PRIVATE main.cc)
target_link_libraries(main PRIVATE hello_world)

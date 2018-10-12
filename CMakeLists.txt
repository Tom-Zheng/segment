
cmake_minimum_required (VERSION 3.10)
set(name "segment")
project ( ${name} )

# cmake module
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)


# c++ version
set (CMAKE_CXX_STANDARD 11)

set (WIN_LIB_PATH "D:/libs")

file (GLOB headers_h "./*.h")
file (GLOB headers_hpp "./*.hpp")
set (MY_HEADER_FILES
${headers_h}
${headers_hpp}
)

file (GLOB headers_cpp "./*.cpp")
set (MY_SOURCE_FILES
${headers_cpp}
)


include_directories(
	${PROJECT_SOURCE_DIR}	
)

add_executable(${name}
	${MY_HEADER_FILES}
	${MY_SOURCE_FILES}
	)

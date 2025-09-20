# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appLegiForces_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appLegiForces_autogen.dir\\ParseCache.txt"
  "appLegiForces_autogen"
  )
endif()

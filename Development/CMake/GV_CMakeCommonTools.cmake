INCLUDE (GV_CMakeCommon)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/Inc)

foreach (it ${projectLibList})
	INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/../${it}/Inc)
endforeach (it)



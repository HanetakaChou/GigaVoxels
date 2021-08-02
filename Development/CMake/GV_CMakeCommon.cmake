#----------------------------------------------------------------
# PROJECT common CMake file
#----------------------------------------------------------------



# LIBRARY_PATH
set (LIBRARY_PATH ${CMAKE_CURRENT_BINARY_DIR})
file (TO_NATIVE_PATH ${LIBRARY_PATH} LIBRARY_PATH)

# CXX_STANDARD_LIBRARIES
SET (CMAKE_CXX_STANDARD_LIBRARIES "")

#-----------------------------------------------
# Defines files lists
#-----------------------------------------------

FILE (GLOB_RECURSE incList "*.h*")
FILE (GLOB_RECURSE inlList "*.inl")
FILE (GLOB_RECURSE cppList "*.cpp")
FILE (GLOB_RECURSE cList "*.c")
FILE (GLOB_RECURSE cuList "*.cu")
FILE (GLOB_RECURSE uiList "*.ui")
FILE (GLOB_RECURSE rcList "*.qrc")

SET (srcList ${cppList} ${cList} ${cuList})

#-----------------------------------------------
# Manage generated files 
#-----------------------------------------------

SET (moclist)
FOREACH (it ${incList})
	GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
	FILE(READ ${infile} _contents)
	STRING(REGEX MATCH "Q_OBJECT" _match "${_contents}")
	IF(NOT ("${_match}" STREQUAL "") )
		LIST(APPEND moclist ${it})	
	ENDIF(NOT ("${_match}" STREQUAL "") )
ENDFOREACH (it)

# Qt if used
SET(genList)
IF (Qt5_FOUND)
	file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Inc)
	file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Src)
	INCLUDE_DIRECTORIES ( BEFORE ${LIBRARY_PATH}/Inc)
	GV_QT5_WRAP_UI (genList ${uiList})
	GV_QT5_ADD_RESOURCES (genList ${rcList})
	GV_QT5_AUTOMOC (genList ${moclist})
ENDIF (Qt5_FOUND)

#-----------------------------------------------
# Define targets
#-----------------------------------------------

STRING (REGEX MATCH "GV_EXE" _matchExe "${GV_TARGET_TYPE}")
STRING (REGEX MATCH "GV_STATIC_LIB" _matchStaticLib "${GV_TARGET_TYPE}")
STRING (REGEX MATCH "GV_SHARED_LIB" _matchSharedLib "${GV_TARGET_TYPE}")
STRING (REGEX MATCH "GV_PLUGIN" _matchGigaSpacePlugin "${GV_TARGET_TYPE}")

STRING (TOUPPER ${PROJECT_NAME} PROJECTDLL)

# GV_TARGET_TYPE
if(_matchExe)
	# GV_EXE
	add_definitions (-D${PROJECTDLL}_MAKEDLL)
	cuda_add_executable (${PROJECT_NAME} ${srcList} ${genList})
elseif(_matchStaticLib)
	# GV_STATIC_LIB
	add_definitions (-D${PROJECTDLL}_MAKELIB)
	cuda_add_library (${PROJECT_NAME} STATIC ${srcList} ${genList})
elseif(_matchSharedLib)
	# GV_SHARED_LIB
	add_definitions (-D${PROJECTDLL}_MAKEDLL)
	cuda_add_library (${PROJECT_NAME} SHARED ${srcList} ${genList})
elseif(_matchGigaSpacePlugin)
	# GV_PLUGIN
	add_definitions (-D${PROJECTDLL}_MAKEDLL)
	cuda_add_library (${PROJECT_NAME} SHARED ${srcList} ${genList})
	if ( NOT PLUGIN_EXTENSION )
		set( PLUGIN_EXTENSION "gvp" )
	endif ( NOT PLUGIN_EXTENSION )
else(_matchExe)
	message (FATAL_ERROR "Not set correct GV_TARGET_TYPE ")
endif(_matchExe)

# Before SET_TARGET_PROPERTIES
foreach (it ${projectLibList})
	TARGET_LINK_LIBRARIES( ${PROJECT_NAME} ${it})
endforeach (it)

SET_TARGET_PROPERTIES (${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ".d")

# LINUX Operating System
if(UNIX)

# Copy binary files
#-----------------------------------------------
if(NOT RELEASE_BIN_DIR)
	message (FATAL_ERROR "Not set RELEASE_BIN_DIR")
endif(NOT RELEASE_BIN_DIR)

file(MAKE_DIRECTORY ${RELEASE_BIN_DIR})

if(_matchExe )
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/${PROJECT_NAME}.d\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/${PROJECT_NAME}.d\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD 
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/${PROJECT_NAME}\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/${PROJECT_NAME}\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
elseif(_matchSharedLib)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD 
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
elseif(_matchStaticLib)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.a\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.a\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD 
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.a\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.a\" \"${RELEASE_BIN_DIR}\" \; fi'
		)
elseif(_matchGigaSpacePlugin)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \"${RELEASE_BIN_DIR}/lib${PROJECT_NAME}.d.${PLUGIN_EXTENSION}\" \; fi'
		)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD 
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \"${RELEASE_BIN_DIR}/lib${PROJECT_NAME}.${PLUGIN_EXTENSION}\" \; fi'
		)
else(_matchExe)
	message (FATAL_ERROR "Not set correct GV_TARGET_TYPE ")
endif(_matchExe)

# Copy library files
#-----------------------------------------------
if(NOT RELEASE_LIB_DIR)
	message (FATAL_ERROR "Not set RELEASE_LIB_DIR")
endif(NOT RELEASE_LIB_DIR)

file(MAKE_DIRECTORY ${RELEASE_LIB_DIR})

if(_matchSharedLib)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.d.so\" \"${RELEASE_LIB_DIR}\" \; fi'
		)
	ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD 
		COMMAND bash -c 'if test -e \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \; then ${CMAKE_COMMAND} -E copy_if_different \"${LIBRARY_PATH}/lib${PROJECT_NAME}.so\" \"${RELEASE_LIB_DIR}\" \; fi'
		)
endif(_matchSharedLib)

elseif (WIN32)

#-----------------------------------------------
# Manage Win32 definitions
#-----------------------------------------------
ADD_DEFINITIONS (-DWIN32 -D_WINDOWS)
if (NOT USE_FULL_WIN32_H)
	ADD_DEFINITIONS (-DWIN32_LEAN_AND_MEAN)
endif (NOT USE_FULL_WIN32_H)

#-----------------------------------------------
# A macro for post build copy
#-----------------------------------------------
MACRO(POST_BUILD_COPY Src Dst)
FILE(TO_NATIVE_PATH ${Src} SrcNative)
FILE(TO_NATIVE_PATH ${Dst} DstNative)
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
	COMMAND if EXIST \"${SrcNative}\" \(
	COMMAND 	echo F | xcopy /d /y /i \"${SrcNative}\" \"${DstNative}\" 
	COMMAND 	if errorlevel 1 \( 
	COMMAND			echo Error can't copy \"${SrcNative}\" to \"${DstNative}\"
	COMMAND			exit 1 
	COMMAND		\)
	COMMAND \)
	)
ENDMACRO(POST_BUILD_COPY)

# Copy binary files
#-----------------------------------------------
IF (NOT RELEASE_BIN_DIR)
	message (FATAL_ERROR "Not set RELEASE_BIN_DIR")
ENDIF(NOT RELEASE_BIN_DIR )

file(MAKE_DIRECTORY ${RELEASE_BIN_DIR})

IF(_matchExe)
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.exe\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.exe\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.exe\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.exe\" copy \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.exe\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.exe\")

ELSE(_matchExe)

IF(_matchSharedLib)
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.dll\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.dll\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.dll\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.dll\" copy \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.dll\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.dll\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.so\" copy \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.dll\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.so\")
ENDIF(_matchSharedLib)

IF(_matchGigaSpacePlugin)
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.dll\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.dll\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.${PLUGIN_EXTENSION}\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.pdb\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.d.pdb\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
	IF EXIST \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.dll\" copy \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.dll\" \"${RELEASE_BIN_DIR}/${PROJECT_NAME}.${PLUGIN_EXTENSION}\")
ENDIF(_matchGigaSpacePlugin)

ENDIF(_matchExe)

# Copy library files
#-----------------------------------------------
IF ( NOT RELEASE_LIB_DIR )
	message (FATAL_ERROR "Not set RELEASE_LIB_DIR")
ENDIF ( NOT RELEASE_LIB_DIR )

file(MAKE_DIRECTORY ${RELEASE_LIB_DIR})

ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
		IF EXIST \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.lib\" copy \"${LIBRARY_PATH}\\DEBUG\\${PROJECT_NAME}.d.lib\" \"${RELEASE_LIB_DIR}/${PROJECT_NAME}.d.lib\")
ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
		IF EXIST \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.lib\" copy \"${LIBRARY_PATH}\\RELEASE\\${PROJECT_NAME}.lib\" \"${RELEASE_LIB_DIR}/${PROJECT_NAME}.lib\")

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)



#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------

#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)

#----------------------------------------------------------------
# LINUX Operating System
#----------------------------------------------------------------

if (UNIX)

elseif (WIN32)

#----------------------------------------------------------------
# NV TOOLS library settings
#----------------------------------------------------------------

set (GV_NVTOOLS_RELEASE "${CUDA_TOOLKIT_ROOT_DIR}/../../../NVIDIA Corporation/NvToolsExt")
set (GV_NVTOOLS_INC "${GV_NVTOOLS_RELEASE}/include")
set (GV_NVTOOLS_LIB "${GV_NVTOOLS_RELEASE}/lib")
set (GV_NVTOOLS_BIN "${GV_NVTOOLS_RELEASE}/bin")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_NVTOOLS_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
	LINK_DIRECTORIES ("${GV_NVTOOLS_LIB}/Win32")
ELSE ()
	LINK_DIRECTORIES ("${GV_NVTOOLS_LIB}/x64")
ENDIF ()
	
#----------------------------------------------------------------
# Set LINK libraries
#----------------------------------------------------------------

IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
	SET (nvtoolsLib "nvToolsExt32_1")
ELSE ()
	SET (nvtoolsLib "nvToolsExt64_1")
ENDIF ()

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (optimized ${it} debug ${it})

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)


#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------

#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)

#----------------------------------------------------------------
# CUDPP library settings
#----------------------------------------------------------------

set (GV_CUDPP_RELEASE "${GV_ROOT}/External/CommonLibraries/cudpp-2.1")
set (GV_CUDPP_INC "${GV_CUDPP_RELEASE}/include")
set (GV_CUDPP_LIB "${GV_CUDPP_RELEASE}/build/lib")
	
#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_CUDPP_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_CUDPP_LIB})

#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

IF (WIN32)
	IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
		SET (cudppLib "cudpp32")
	ELSE ()
		SET (cudppLib "cudpp64")
	ENDIF ()
ELSE ()
	SET (cudppLib "cudpp")
ENDIF ()

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

IF (WIN32)
	LINK_LIBRARIES (optimized ${cudppLib} debug ${cudppLib}d)
ELSE ()
	IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
		LINK_LIBRARIES (optimized ${cudppLib} debug ${cudppLib}d)
	ELSE ()
		LINK_LIBRARIES (optimized ${cudppLib} debug ${cudppLib}64d)
	ENDIF ()
ENDIF ()

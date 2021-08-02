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

#----------------------------------------------------------------
# DCMTK library settings
#----------------------------------------------------------------

# Search for DCMTK
find_package( DCMTK )
IF ( DCMTK_FOUND )
	set (GV_DCMTK_INC ${DCMTK_INCLUDE_DIRS})
	set (GV_DCMTK_LIB ${DCMTK_LIBRARIES})
ELSE ()
	MESSAGE ( STATUS "WARNING : Unable to find DCMTK on the system" )
ENDIF ()

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_DCMTK_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_DCMTK_LIB})

#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
	SET (dcmtkLib "ofstd" "dcmdata" "dcmimgle" "dcmimage" "ijg8" "ijg12" "ijg16" "libi2d" "dcmjpeg" "dcmnet" "dcmdsig" "dcmsr" "dcmpstat" "dcmtls" "dcmwlm" "dcmjpls" "dcmqrdb" "oflog" "charls")
ELSE ()
	SET (dcmtkLib "ofstd" "dcmdata" "dcmimgle" "dcmimage" "ijg8" "ijg12" "ijg16" "dcmjpeg" "dcmnet" "dcmdsig" "dcmsr" "dcmpstat" "dcmtls" "dcmwlm" "dcmjpls" "dcmqrdb" "oflog")
ENDIF ()

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

FOREACH (it ${dcmtkLib})
	LINK_LIBRARIES (optimized ${it} debug ${it})
ENDFOREACH (it)

elseif (WIN32)

#----------------------------------------------------------------
# DCMTK library settings
#----------------------------------------------------------------

set (GV_DCMTK_RELEASE "${GV_EXTERNAL}/DCMTK")
set (GV_DCMTK_INC "${GV_DCMTK_RELEASE}/include")
set (GV_DCMTK_LIB "${GV_DCMTK_RELEASE}/lib")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_DCMTK_INC})

#----------------------------------------------------------------
# Set LINK libraries
#----------------------------------------------------------------

SET (dcmtkLib "ofstd" "dcmdata" "dcmimgle" "dcmimage" "ijg8" "ijg12" "ijg16" "libi2d" "dcmjpeg" "dcmnet" "dcmdsig" "dcmsr" "dcmpstat" "dcmtls" "dcmwlm" "dcmjpls" "dcmqrdb" "oflog" "charls")

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

FOREACH (it ${dcmtkLib})
	LINK_LIBRARIES (optimized ${it} debug ${it}.d)
ENDFOREACH (it)

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)

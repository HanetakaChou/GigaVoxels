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
# TinyXML library settings
#----------------------------------------------------------------

find_package (PkgConfig REQUIRED)
pkg_check_modules(TINYXML REQUIRED tinyxml)
if (NOT TINYXML_FOUND)
	message (FATAL_ERROR "system doesn't have tinyxml")
endif()
set (GV_TINYXML_INC "${TINYXML_INCLUDE_DIRS}")
set (GV_TINYXML_LIB "${TINYXML_LIBRARIES}")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_TINYXML_INC})

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (${GV_TINYXML_LIB})

elseif (WIN32)

#----------------------------------------------------------------
# TinyXML library settings
#----------------------------------------------------------------

set (GV_TINYXML_RELEASE "${GV_EXTERNAL}/tinyxml")
set (GV_TINYXML_INC "${GV_TINYXML_RELEASE}/include")
set (GV_TINYXML_LIB_DIR "${GV_TINYXML_RELEASE}/lib")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_TINYXML_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_TINYXML_LIB_DIR})

#----------------------------------------------------------------
# Set LINK libraries
#----------------------------------------------------------------

SET (TinyXMLLib "tinyxml")

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (optimized ${TinyXMLLib} debug ${TinyXMLLib}.d)

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)

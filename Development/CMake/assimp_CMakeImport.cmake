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
# ASSIMP library settings
#----------------------------------------------------------------

find_package (PkgConfig REQUIRED)
pkg_check_modules(ASSIMP REQUIRED assimp)
if (NOT ASSIMP_FOUND)
	message (FATAL_ERROR "system doesn't have assimp")
endif()
set (GV_ASSIMP_INC "${ASSIMP_INCLUDE_DIRS}")
set (GV_ASSIMP_LIB "${ASSIMP_LIBRARIES}")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_ASSIMP_INC})

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (${GV_ASSIMP_LIB})

elseif (WIN32)

#----------------------------------------------------------------
# ASSIMP library settings
#----------------------------------------------------------------

set (GV_ASSIMP_RELEASE "${GV_EXTERNAL}/assimp")
set (GV_ASSIMP_INC "${GV_ASSIMP_RELEASE}/include")
set (GV_ASSIMP_LIB_DIR "${GV_ASSIMP_RELEASE}/lib")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_ASSIMP_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_ASSIMP_LIB_DIR})

#----------------------------------------------------------------
# Set LINK libraries
#----------------------------------------------------------------

SET (assimpLib "assimp")

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (optimized ${assimpLib} debug ${assimpLib}d)

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)

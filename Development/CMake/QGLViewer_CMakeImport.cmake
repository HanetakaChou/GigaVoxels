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
# QGLVIEWER library settings
#----------------------------------------------------------------

set (GV_QGLVIEWER_RELEASE "/usr")
set (GV_QGLVIEWER_INC "${GV_QGLVIEWER_RELEASE}/include")
find_library(GV_QGLVIEWER_LIB QGLViewer-qt5 PATHS "/usr/lib/x86_64-linux-gnu" "/usr/lib64" REQUIRED)
string(STRIP ${GV_QGLVIEWER_LIB} GV_QGLVIEWER_LIB)
if ( "${GV_QGLVIEWER_LIB}" STREQUAL "" )
	message (FATAL_ERROR "system doesn't have QGLViewer-qt5")
endif()

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_QGLVIEWER_INC})
	
#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (${GV_QGLVIEWER_LIB})

elseif (WIN32)

#----------------------------------------------------------------
# QGLVIEWER library settings
#----------------------------------------------------------------

set (GV_QGLVIEWER_RELEASE "${GV_EXTERNAL}/QGLViewer")
set (GV_QGLVIEWER_INC "${GV_QGLVIEWER_RELEASE}/include")
set (GV_QGLVIEWER_LIB_DIR "${GV_QGLVIEWER_RELEASE}/lib")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_QGLVIEWER_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_QGLVIEWER_LIB_DIR})
#----------------------------------------------------------------
# Set LINK libraries
#----------------------------------------------------------------

SET (qglviewerLib "QGLViewer")

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (optimized ${qglviewerLib}2.lib debug ${qglviewerLib}d2.lib)

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)

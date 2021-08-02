#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------
	
#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)
	
#----------------------------------------------------------------
# Search for OpenGL
#----------------------------------------------------------------
find_package (OpenGL REQUIRED)
if (NOT OPENGL_FOUND)
	message (FATAL_ERROR "system doesn't have OpenGL")
endif()
if (NOT OPENGL_GLU_FOUND)
	message (FATAL_ERROR "system doesn't have GLU")
endif()
set (GV_GLU_INC "${OPENGL_INCLUDE_DIR}")
set (GV_GLU_LIB "${OPENGL_glu_LIBRARY}")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_GLU_INC})

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (${GV_GLU_LIB})

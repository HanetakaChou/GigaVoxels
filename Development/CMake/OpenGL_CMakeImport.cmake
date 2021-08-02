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
set (OpenGL_GL_PREFERENCE LEGACY)
find_package (OpenGL REQUIRED)
if (NOT OPENGL_FOUND)
	message (FATAL_ERROR "system doesn't have OpenGL")
endif()
if (NOT OPENGL_GLU_FOUND)
	message (FATAL_ERROR "system doesn't have GLU")
endif()
set (GV_OPENGL_INC "${OPENGL_INCLUDE_DIR}")
set (GV_OPENGL_LIB "${OPENGL_gl_LIBRARY}")


#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_OPENGL_INC})

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES (${GV_OPENGL_LIB})

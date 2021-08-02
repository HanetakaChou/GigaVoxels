#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------
	 
#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

IF ( "${gvviewerLib}" STREQUAL "" )
	SET (gvviewerLib "GvViewerCore" "GvViewerScene" "GvViewerGui")
ENDIF ()

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

FOREACH (it ${gvviewerLib})
	INCLUDE_DIRECTORIES (${GV_ROOT}/Development/Tools/GigaVoxelsViewer/${it}/Inc)
	IF (WIN32)
		IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
			INCLUDE_DIRECTORIES (${GV_ROOT}/Generated_VC10_x86/Tools/GigaVoxelsViewer/${it}/Inc)
		ELSE ()
			INCLUDE_DIRECTORIES (${GV_ROOT}/Generated_VC10_x64/Tools/GigaVoxelsViewer/${it}/Inc)
		ENDIF ()
	ELSE ()
		INCLUDE_DIRECTORIES (${GV_ROOT}/Generated_Linux/Tools/GigaVoxelsViewer/${it}/Inc)
	ENDIF ()
ENDFOREACH (it)

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_RELEASE}/Tools/GigaVoxelsViewer/Lib)

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------
		
FOREACH (it ${gvviewerLib})
	LINK_LIBRARIES (optimized ${it} debug ${it}.d)
ENDFOREACH (it)

#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------

#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

IF ( "${gigaspaceLib}" STREQUAL "" )
	SET (gigaspaceLib "GigaSpace")
ENDIF ()
		
#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

FOREACH (it ${gigaspaceLib})
	INCLUDE_DIRECTORIES (${GV_ROOT}/Development/Library/${it})
ENDFOREACH (it)

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_RELEASE}/Lib)

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

FOREACH (it ${gigaspaceLib})
	LINK_LIBRARIES (optimized ${it} debug ${it}.d)
ENDFOREACH (it)

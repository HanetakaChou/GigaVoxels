#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------
	
#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)

#----------------------------------------------------------------
# QT library settings
#----------------------------------------------------------------

find_package(Qt5 COMPONENTS Core Widgets Gui OpenGL Xml REQUIRED)
if (NOT Qt5_FOUND)
	message (FATAL_ERROR "system doesn't have Qt5")
endif()

# Where to find the uic, moc and rcc tools
set (GV_QT_UIC_EXECUTABLE ${Qt5Widgets_UIC_EXECUTABLE})
set (GV_QT_MOC_EXECUTABLE ${Qt5Core_MOC_EXECUTABLE})
set (GV_QT_RCC_EXECUTABLE ${Qt5Core_RCC_EXECUTABLE})

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${Qt5Core_INCLUDE_DIRS})
INCLUDE_DIRECTORIES (${Qt5Widgets_INCLUDE_DIRS})
INCLUDE_DIRECTORIES (${Qt5Gui_INCLUDE_DIRS})
INCLUDE_DIRECTORIES (${Qt5OpenGL_INCLUDE_DIRS})
INCLUDE_DIRECTORIES (${Qt5Xml_INCLUDE_DIRS})
		
#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------
		
LINK_LIBRARIES (${Qt5Core_LIBRARIES})
LINK_LIBRARIES (${Qt5Widgets_LIBRARIES})
LINK_LIBRARIES (${Qt5Gui_LIBRARIES})
LINK_LIBRARIES (${Qt5OpenGL_LIBRARIES})
LINK_LIBRARIES (${Qt5Xml_LIBRARIES})

#----------------------------------------------------------------
# Define MACRO to wrap Qt files (uic, moc, rcc...)
#----------------------------------------------------------------
	
MACRO (GV_QT5_WRAP_UI outfiles) 
	set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)
    cmake_parse_arguments(_GV_QT5_WRAP_UI "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(ui_files ${_GV_QT5_WRAP_UI_UNPARSED_ARGUMENTS})
    set(ui_options ${_GV_QT5_WRAP_UI_OPTIONS})
    
    foreach(it ${ui_files})
        get_filename_component(outfile ${it} NAME_WE)
        get_filename_component(infile ${it} ABSOLUTE)
		set(outfile ${CMAKE_CURRENT_BINARY_DIR}/Inc/UI_${outfile}.h)
   		get_filename_component(outfile ${outfile} ABSOLUTE)
		add_custom_command(OUTPUT ${outfile}
			COMMAND ${GV_QT_UIC_EXECUTABLE}
			ARGS ${ui_options} -o ${outfile} ${infile}
			MAIN_DEPENDENCY ${infile} VERBATIM)
		set_source_files_properties(${infile} PROPERTIES SKIP_AUTOUIC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOMOC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOUIC ON)
        list(APPEND ${outfiles} ${outfile})
		#set(${outfiles} ${${outfiles}} ${outfile})
    endforeach()

    #set(${outfiles} ${${outfiles}} PARENT_SCOPE)
ENDMACRO (GV_QT5_WRAP_UI)
	
MACRO (GV_QT5_ADD_RESOURCES outfiles)
	set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)
    cmake_parse_arguments(_GV_QT5_ADD_RESOURCES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(rcc_files ${_GV_QT5_ADD_RESOURCES_UNPARSED_ARGUMENTS})
    set(rcc_options ${_GV_QT5_ADD_RESOURCES_OPTIONS})
    
    foreach(it ${rcc_files})
        get_filename_component(outfilename ${it} NAME_WE)
        get_filename_component(infile ${it} ABSOLUTE)
        set(outfile ${CMAKE_CURRENT_BINARY_DIR}/Src/${outfilename}.qrc.cpp)
   		get_filename_component(outfile ${outfile} ABSOLUTE)
		add_custom_command(OUTPUT ${outfile}
			COMMAND ${GV_QT_RCC_EXECUTABLE}
			ARGS ${rcc_options} --name ${outfilename} --output ${outfile} ${infile}
			MAIN_DEPENDENCY ${infile} VERBATIM)
		set_source_files_properties(${infile} PROPERTIES SKIP_AUTOUIC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOMOC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOUIC ON)
        list(APPEND ${outfiles} ${outfile})
		#set(${outfiles} ${${outfiles}} ${outfile})
    endforeach()

    #set(${outfiles} ${${outfiles}} PARENT_SCOPE)
ENDMACRO (GV_QT5_ADD_RESOURCES)
	
MACRO (GV_QT5_AUTOMOC outfiles) 
    set(options)
    set(oneValueArgs)
    set(multiValueArgs OPTIONS)
    cmake_parse_arguments(_GV_QT5_AUTOMOC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    set(moc_files ${_GV_QT5_AUTOMOC_UNPARSED_ARGUMENTS})
    set(moc_options ${_GV_QT5_AUTOMOC_OPTIONS})

    foreach(it ${moc_files})
        get_filename_component(outfile ${it} NAME_WE)
        get_filename_component(infile ${it} ABSOLUTE)
		set(outfile ${CMAKE_CURRENT_BINARY_DIR}/Src/${outfile}.moc.cpp)
   		get_filename_component(outfile ${outfile} ABSOLUTE)
		add_custom_command(OUTPUT ${outfile}
			COMMAND ${GV_QT_MOC_EXECUTABLE}
			ARGS ${moc_options} -o ${outfile} ${infile}
			MAIN_DEPENDENCY ${infile} VERBATIM)
		set_source_files_properties(${infile} PROPERTIES SKIP_AUTOUIC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOMOC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOUIC ON)
        list(APPEND ${outfiles} ${outfile})
		#set(${outfiles} ${${outfiles}} ${outfile})
    endforeach()

    #set(${outfiles} ${${outfiles}} PARENT_SCOPE)
ENDMACRO (GV_QT5_AUTOMOC)

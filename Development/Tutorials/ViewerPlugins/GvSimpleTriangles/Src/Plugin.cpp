/*
 * GigaVoxels - GigaSpace
 *
 * Website: http://gigavoxels.inrialpes.fr/
 *
 * Contributors: GigaVoxels Team
 *
 * Copyright (C) 2007-2015 INRIA - LJK (CNRS - Grenoble University), All rights reserved.
 */

/** 
 * @version 1.0
 */

#include "Plugin.h"

/******************************************************************************
 ******************************* INCLUDE SECTION ******************************
 ******************************************************************************/

// Project
#include "PluginConfig.h"
#include "CustomEditor.h"

// System
#include <cassert>
#include <iostream>

// STL
#include <sstream>

// OpenGL
#include <GsGL/glew.h>
#include <GL/freeglut.h>

// Project
#include "SampleCore.h"

// GvViewer
#include <GvvPluginManager.h>
#include <GvvApplication.h>
#include <GvvMainWindow.h>
#include <Gvv3DWindow.h>
#include <GvvPipelineManager.h>
#include <GvvEditorWindow.h>
#include <GvvPipelineEditor.h>
#include <GvvPipelineInterfaceViewer.h>
	
/******************************************************************************
 ****************************** NAMESPACE SECTION *****************************
 ******************************************************************************/

// VtViewer
using namespace GvViewerCore;
using namespace GvViewerGui;

// STL
using namespace std;

/******************************************************************************
 ************************* DEFINE AND CONSTANT SECTION ************************
 ******************************************************************************/

/******************************************************************************
 ***************************** TYPE DEFINITION ********************************
 ******************************************************************************/

/******************************************************************************
 ***************************** METHOD DEFINITION ******************************
 ******************************************************************************/

/******************************************************************************
 * 
 ******************************************************************************/
extern "C" GVSIMPLETRIANGLES_EXPORT GvvPluginInterface* createPlugin( GvvPluginManager& pManager )
{
    //return new Plugin( pManager );
	Plugin* plugin = new Plugin( pManager );
	assert( plugin != NULL );

	return plugin;
}

/******************************************************************************
 * Default constructor
 ******************************************************************************/
Plugin::Plugin( GvvPluginManager& pManager )
:	_manager( pManager )
,	_name( "GvSimpleTriangles" )
,	_exportName( "Format A" )
,	_pipeline( NULL )
{
	initialize();
}

/******************************************************************************
 * Default constructor
 ******************************************************************************/
Plugin::~Plugin()
{
	finalize();
}

/******************************************************************************
 *
 ******************************************************************************/
void Plugin::initialize()
{
	GvViewerGui::GvvApplication& application = GvViewerGui::GvvApplication::get();
	GvViewerGui::GvvMainWindow* mainWindow = application.getMainWindow();

	// Register custom editor's factory method
	GvViewerGui::GvvEditorWindow* editorWindow = mainWindow->getEditorWindow();
	editorWindow->registerEditorFactory( SampleCore::cTypeName, &CustomEditor::create );

	// Create the GigaVoxels pipeline
	_pipeline = new SampleCore();

	// Pipeline BEGIN
	if ( _pipeline != NULL )
	{
		assert( _pipeline != NULL );
		_pipeline->init();

		GvViewerGui::Gvv3DWindow* window3D = mainWindow->get3DWindow();
		GvvPipelineInterfaceViewer* viewer = window3D->getPipelineViewer();
		_pipeline->resize( viewer->size().width(), viewer->size().height() );
	}

	// Tell the viewer that a new pipeline has been added
	GvvPipelineManager::get().addPipeline( _pipeline );
}

/******************************************************************************
 *
 ******************************************************************************/
void Plugin::finalize()
{
	// Tell the viewer that a pipeline is about to be removed
	GvvPipelineManager::get().removePipeline( _pipeline );

	// Destroy the pipeline
	delete _pipeline;
	_pipeline = NULL;

	GvViewerGui::GvvApplication& application = GvViewerGui::GvvApplication::get();
	GvViewerGui::GvvMainWindow* mainWindow = application.getMainWindow();
	
	// Register custom editor's factory method
	GvViewerGui::GvvEditorWindow* editorWindow = mainWindow->getEditorWindow();
	editorWindow->unregisterEditorFactory( SampleCore::cTypeName );
}

/******************************************************************************
 * 
 ******************************************************************************/
const string& Plugin::getName()
{
    return _name;
}

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

#include "CustomEditor.h"

/******************************************************************************
 ******************************* INCLUDE SECTION ******************************
 ******************************************************************************/

// Qt
#include <QUrl>
#include <QFileDialog>
#include <QMessageBox>
#include <QVBoxLayout>
#include <QToolBar>

// GvViewer
#include "Gvv3DWindow.h"
#include "GvvPipelineInterfaceViewer.h"
#include "GvvPluginManager.h"

#include "GvvApplication.h"
#include "GvvMainWindow.h"
#include "Gvv3DWindow.h"
#include "GvvPipelineInterfaceViewer.h"
#include "GvvPipelineInterface.h"

// Project
#include "CustomSectionEditor.h"

// STL
#include <iostream>

// System
#include <cassert>

/******************************************************************************
 ****************************** NAMESPACE SECTION *****************************
 ******************************************************************************/

// GvViewer
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
 * Creator function
 *
 * @param pParent parent widget
 * @param pBrowsable pipeline element from which the editor will be associated
 *
 * @return the editor associated to the GigaVoxels pipeline
 ******************************************************************************/
GvvEditor* CustomEditor::create( QWidget* pParent, GvViewerCore::GvvBrowsable* pBrowsable )
{
	return new CustomEditor( pParent );
}

/******************************************************************************
 * Default constructor
 ******************************************************************************/
CustomEditor::CustomEditor( QWidget* pParent, Qt::WindowFlags pFlags )
:	GvvPipelineEditor( pParent, pFlags )
,	_customSectionEditor( NULL )
{
	_customSectionEditor = new CustomSectionEditor( pParent, pFlags );

	_sectionEditors.push_back( _customSectionEditor );
}

/******************************************************************************
 * Destructor
 ******************************************************************************/
CustomEditor::~CustomEditor()
{
}

/*
 * GigaVoxels - GigaSpace
 *
 * Website: http://gigavoxels.inrialpes.fr/
 *
 * Contributors: GigaVoxels Team
 *
 * BSD 3-Clause License:
 *
 * Copyright (C) 2007-2015 INRIA - LJK (CNRS - Grenoble University), All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the organization nor the names  of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/** 
 * @version 1.0
 */

#ifndef _GVV_GL_SCENE_MANAGER_LISTENER_H_
#define _GVV_GL_SCENE_MANAGER_LISTENER_H_

/******************************************************************************
 ******************************* INCLUDE SECTION ******************************
 ******************************************************************************/

// GvViewer
#include "GvvCoreConfig.h"

/******************************************************************************
 ************************* DEFINE AND CONSTANT SECTION ************************
 ******************************************************************************/

/******************************************************************************
 ***************************** TYPE DEFINITION ********************************
 ******************************************************************************/

/******************************************************************************
 ******************************** CLASS USED **********************************
 ******************************************************************************/

// GvViewer
namespace GvViewerCore
{
	class GvvGLSceneManager;
	class GvvGLSceneInterface;
}

/******************************************************************************
 ****************************** CLASS DEFINITION ******************************
 ******************************************************************************/

namespace GvViewerCore
{

/**
 * GvPluginManager
 */
class GVVIEWERCORE_EXPORT GvvGLSceneManagerListener
{

	/**************************************************************************
     ***************************** FRIEND SECTION *****************************
     **************************************************************************/

	/**
	 * ...
	 */
	friend class GvvGLSceneManager;

	/**************************************************************************
     ***************************** PUBLIC SECTION *****************************
     **************************************************************************/

public:

    /******************************* INNER TYPES *******************************/

    /******************************* ATTRIBUTES *******************************/

    /******************************** METHODS *********************************/
	
    /**************************************************************************
     **************************** PROTECTED SECTION ***************************
     **************************************************************************/

protected:

    /******************************* INNER TYPES *******************************/

    /******************************* ATTRIBUTES *******************************/

	/******************************** METHODS *********************************/

	/**
     * Constructor
     */
    GvvGLSceneManagerListener();

	/**
     * Destructor
     */
    virtual ~GvvGLSceneManagerListener();

	/**
	 * Add a scene.
	 *
	 * @param pScene the scene to add
	 */
	virtual void onGLSceneAdded( GvvGLSceneInterface* pScene );

	/**
	 * Remove a scene.
	 *
	 * @param pScene the scene to remove
	 */
	virtual void onGLSceneRemoved( GvvGLSceneInterface* pScene );

	/**
	 * Tell that a scene has been modified.
	 *
	 * @param pScene the modified scene
	 */
	virtual void onGLSceneModified( GvvGLSceneInterface* pScene );

    /**************************************************************************
     ***************************** PRIVATE SECTION ****************************
     **************************************************************************/

private:

    /******************************* INNER TYPES *******************************/

    /******************************* ATTRIBUTES *******************************/

    /******************************** METHODS *********************************/

};

} // namespace GvViewerCore

#endif

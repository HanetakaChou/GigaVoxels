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

#ifndef _GV_I_PROVIDER_H_
#define _GV_I_PROVIDER_H_

/******************************************************************************
 ******************************* INCLUDE SECTION ******************************
 ******************************************************************************/

// GigaVoxels
#include "GvCore/GsCoreConfig.h"
#include "GvCore/GsVectorTypesExt.h"
#include "GvStructure/GsIDataStructure.h"
#include "GvStructure/GsIDataProductionManager.h"
#include "GvCore/GsLinearMemory.h"

// Loki
#include <loki/TypeManip.h>

/******************************************************************************
 ************************* DEFINE AND CONSTANT SECTION ************************
 ******************************************************************************/

/******************************************************************************
 ***************************** TYPE DEFINITION ********************************
 ******************************************************************************/

/******************************************************************************
 ******************************** CLASS USED **********************************
 ******************************************************************************/

/******************************************************************************
 ****************************** CLASS DEFINITION ******************************
 ******************************************************************************/

// TO DO
//
// For Fabrice, passing localization info is not good for the API. This is implementation details...

namespace GvCore
{

/** 
 * @class GsIProvider
 *
 * @brief The GsIProvider class provides the mecanisms to produce data
 * following data requests emitted during N-tree traversal (rendering).
 *
 * @ingroup GvCore
 *
 * This class is the base class for all host producers.
 *
 * It is the main user entry point to produce data from CPU, for instance,
 * loading data from disk or procedurally generating data.
 */
class GIGASPACE_EXPORT GsIProvider
{

	/**************************************************************************
	 ***************************** PUBLIC SECTION *****************************
	 **************************************************************************/

public:

	/****************************** INNER TYPES *******************************/

	/******************************* ATTRIBUTES *******************************/

	struct GsProductionInfo
	{
		//unsigned int _objectID;	// for the moment, 1 producer associated to 1 object (could be changed)
		unsigned int _nbElements;
		unsigned int _offset;
	};
	
	GsProductionInfo _productionInfo;
	
	/******************************** METHODS *********************************/

	/**
	 * Destructor
	 */
	virtual ~GsIProvider();

	/**
	 * Initialize
	 *
	 * @param pDataStructure data structure
	 * @param pDataProductionManager data production manager
	 */
	virtual void initialize( GvStructure::GsIDataStructure* pDataStructure, GvStructure::GsIDataProductionManager* pDataProductionManager ) = 0;

	/**
	 * Finalize
	 */
	virtual void finalize();

	/**
	 * This method is called by the cache manager when you have to produce data for a given pool.
	 *
	 * @param pNumElems the number of elements you have to produce.
	 * @param pNodeAddressCompactList a list containing the addresses of the numElems nodes concerned.
	 * @param pElemAddressCompactList a list containing numElems addresses where you need to store the result.
	 */
	virtual void produceData( uint pNumElems,
										GvCore::GsLinearMemory< uint >* pNodesAddressCompactList,
										GvCore::GsLinearMemory< uint >* pElemAddressCompactList,
										Loki::Int2Type< 0 > ) = 0;

	/**
	 * This method is called by the cache manager when you have to produce data for a given pool.
	 *
	 * @param pNumElems the number of elements you have to produce.
	 * @param pNodeAddressCompactList a list containing the addresses of the numElems nodes concerned.
	 * @param pElemAddressCompactList a list containing numElems addresses where you need to store the result.
	 */
	virtual void produceData( uint pNumElems,
										GvCore::GsLinearMemory< uint >* pNodesAddressCompactList,
										GvCore::GsLinearMemory< uint >* pElemAddressCompactList,
										Loki::Int2Type< 1 > ) = 0;

	/**************************************************************************
	 **************************** PROTECTED SECTION ***************************
	 **************************************************************************/

protected:

	/****************************** INNER TYPES *******************************/

	/******************************* ATTRIBUTES *******************************/

	/******************************** METHODS *********************************/

	/**
	 * Constructor
	 */
	GsIProvider();

	/**************************************************************************
	 ***************************** PRIVATE SECTION ****************************
	 **************************************************************************/

private:

	/****************************** INNER TYPES *******************************/

	/******************************* ATTRIBUTES *******************************/

	/******************************** METHODS *********************************/

	/**
	 * Copy constructor forbidden.
	 */
	GsIProvider( const GsIProvider& );

	/**
	 * Copy operator forbidden.
	 */
	GsIProvider& operator=( const GsIProvider& );

};

} // namespace GvCore

/**************************************************************************
 ***************************** INLINE SECTION *****************************
 **************************************************************************/

#include "GsIProvider.inl"

#endif // !_GV_I_PROVIDER_H_

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
 
/******************************************************************************
 ******************************* INCLUDE SECTION ******************************
 ******************************************************************************/

/******************************************************************************
 ****************************** KERNEL DEFINITION *****************************
 ******************************************************************************/

/******************************************************************************
 * This method is called just before the cast of a ray. Use it to initialize any data
 *  you may need. You may also want to modify the initial distance along the ray (tTree).
 *
 * @param pRayStartTree the starting position of the ray in octree's space.
 * @param pRayDirTree the direction of the ray in octree's space.
 * @param pTTree the distance along the ray's direction we start from.
 ******************************************************************************/
__device__
inline void ToreShaderKernel::preShadeImpl( const float3& rayStartTree, const float3& rayDirTree, float& tTree )
{
	_accColor = make_float4( 0.f );
}

/******************************************************************************
 * This method is called after the ray stopped or left the bounding
 * volume. You may want to do some post-treatment of the color.
 ******************************************************************************/
__device__
inline void ToreShaderKernel::postShadeImpl()
{
	if ( _accColor.w >= opacityThreshold )
	{
		_accColor.w = 1.f;
	}
}

/******************************************************************************
 * This method returns the cone aperture for a given distance.
 *
 * @param pTTree the current distance along the ray's direction.
 *
 * @return the cone aperture
 ******************************************************************************/
__device__
inline float ToreShaderKernel::getConeApertureImpl( const float tTree ) const
{
	// Overestimate to avoid aliasing
	const float scaleFactor = 1.333f;

	return k_renderViewContext.pixelSize.x * tTree * scaleFactor * k_renderViewContext.frustumNearINV;
}

/******************************************************************************
 * This method returns the final rgba color that will be written to the color buffer.
 *
 * @return the final rgba color.
 ******************************************************************************/
__device__
inline float4 ToreShaderKernel::getColorImpl() const
{
	return _accColor;
}

/******************************************************************************
 * This method is called before each sampling to check whether or not the ray should stop.
 *
 * @param pRayPosInWorld the current ray's position in world space.
 *
 * @return true if you want to continue the ray. false otherwise.
 ******************************************************************************/
__device__
inline bool ToreShaderKernel::stopCriterionImpl( const float3& rayPosInWorld ) const
{
	return ( _accColor.w >= opacityThreshold );
}

/******************************************************************************
 * This method is called to know if we should stop at the current octree's level.
 *
 * @param pVoxelSize the voxel's size in the current octree level.
 *
 * @return false if you want to stop at the current octree's level. true otherwise.
 ******************************************************************************/
__device__
inline bool ToreShaderKernel::descentCriterionImpl( const float voxelSize ) const
{
	return true;
}

/******************************************************************************
 * This method is called for each sample. For example, shading or secondary rays
 * should be done here.
 *
 * @param pBrickSampler brick sampler
 * @param pSamplePosScene position of the sample in the scene
 * @param pRayDir ray direction
 * @param pRayStep ray step
 * @param pConeAperture cone aperture
 ******************************************************************************/
template< typename SamplerType >
__device__
inline void ToreShaderKernel::runImpl( const SamplerType& brickSampler, const float3 samplePosScene,
										const float3 rayDir, float& rayStep, const float coneAperture )
{
	// Retrieve first channel element : color
	float4 color = brickSampler.template getValue< 0 >( coneAperture );

	// Test opacity
	if ( color.w > 0.0f )
	{
		// Retrieve second channel element : normal
		float4 normal = brickSampler.template getValue< 1 >( coneAperture );

		float3 normalVec = normalize( make_float3( normal.x, normal.y, normal.z ) );
		float3 lightVec = normalize( lightPosition );

		// Lambertian lighting
		float3 rgb = make_float3( color.x, color.y, color.z );// * max( 0.0f, dot( normalVec, lightVec ) );

		color.x = rgb.x;
		color.y = rgb.y;
		color.z = rgb.z;
	}

	// Accumulate the color
	_accColor = _accColor + ( 1.0f - _accColor.w ) * color;
}
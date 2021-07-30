////////////////////////////////////////////////////////////////////////////////
//
// Fragment Shader
//
// Depth Peeling : core program
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// VARYING
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// SAMPLER
////////////////////////////////////////////////////////////////////////////////

//
uniform samplerRECT DepthTex;

//
uniform samplerRECT DepthDep;

////////////////////////////////////////////////////////////////////////////////
// Program
////////////////////////////////////////////////////////////////////////////////

void main( void )
{
	float factor = 1.0 / ( 1.0 - gl_ProjectionMatrix[ 2 ][ 2 ] );

	float Dep = textureRect( DepthDep, gl_FragCoord.xy );
	float depWin = Dep / gl_FragCoord.w;
	float depCam = ( 2.0 * depWin - gl_ProjectionMatrix[ 3 ][ 2 ] ) * factor;

	float zWin = gl_FragCoord.z / gl_FragCoord.w;
	float zCam = ( 2.0 * zWin - gl_ProjectionMatrix[ 3 ][ 2 ] ) * factor;

	// Bit-exact comparison between FP32 z-buffer and fragment depth
	float frontDepth = textureRect( DepthTex, gl_FragCoord.xy ).r;
	if ( zCam <= frontDepth  || ( depCam > 0.0 && frontDepth == 0.0 ) )
	{
		discard;
	}

	// Shade all the fragments behind the z-buffer
	gl_FragColor = zCam;
}
/////////////////////////////////////////////////////////////////////////////////
//
// FRAGMENT SHADER
//
// Shadow Mapping
//
// - 2nd pass
//
// The scene is rendered from the point of view of the camera.
//
// Mandatory :
// - a FBO (frame buffer object) with a unique depth texture bound to its depth attachement
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// VERSION
////////////////////////////////////////////////////////////////////////////////

#version 400

////////////////////////////////////////////////////////////////////////////////
// INPUT
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// UNIFORM
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// OUTPUT
////////////////////////////////////////////////////////////////////////////////

layout (location = 0) out vec4 FragColor;

////////////////////////////////////////////////////////////////////////////////
// PROGRAM
////////////////////////////////////////////////////////////////////////////////
void main()
{
	FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}
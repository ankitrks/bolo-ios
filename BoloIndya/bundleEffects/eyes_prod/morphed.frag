#version 300 es

#define GLFX_USE_UVMORPH

precision mediump float;

in vec2 var_uv;
// in vec3 var_t;
// in vec3 var_b;
// in vec3 var_n;

#ifdef GLFX_USE_UVMORPH
uniform sampler2D glfx_BACKGROUND;
in vec2 var_bg_uv;
#endif

layout( location = 0 ) out vec4 F;

void main()
{
	F = vec4( texture( glfx_BACKGROUND, var_bg_uv ).xyz, 1. );
}

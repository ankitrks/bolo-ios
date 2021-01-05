#version 300 es

precision mediump float;

in vec2 var_uv;
in vec2 var_bg_uv;

uniform sampler2D glfx_BACKGROUND;
uniform sampler2D tex;

layout( location = 0 ) out vec4 F;

void main()
{
	F = vec4( texture( glfx_BACKGROUND, var_bg_uv ).xyz, texture( tex, var_uv ).x );
}

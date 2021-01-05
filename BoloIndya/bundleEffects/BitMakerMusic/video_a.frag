#version 300 es

precision highp float;

in vec2 var_uv;

layout( location = 0 ) out vec4 frag_color;

uniform sampler2D glfx_VIDEO;

void main()
{
	vec2 uv = var_uv;
	uv.x *= 0.5;
	uv.y -= 0.26;
	uv.y *= 0.5;
	frag_color = texture(glfx_VIDEO,uv);
}

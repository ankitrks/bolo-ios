#version 300 es

precision highp sampler2DArray;

layout( location = 0 ) in vec3 attrib_pos;
layout( location = 3 ) in vec2 attrib_uv;

layout(std140) uniform glfx_GLOBAL
{
	mat4 glfx_MVP;
	mat4 glfx_PROJ;
	mat4 glfx_MV;
	vec4 unused_spinner;

	vec4 translate[48];
	vec4 scale[48];
	vec4 rotate[48];

};
layout(std140) uniform glfx_INSTANCES
{
	vec4 glfx_IDATA[48];
};
uniform uint glfx_CURRENT_I;
#define glfx_T_SPAWN (glfx_IDATA[glfx_CURRENT_I].x)
#define glfx_T_ANIM (glfx_IDATA[glfx_CURRENT_I].y)
#define glfx_ANIMKEY (glfx_IDATA[glfx_CURRENT_I].z)

out vec2 var_uv;

void main()
{
	vec2 translating = translate[glfx_CURRENT_I].xy;

	float scaleX = scale[glfx_CURRENT_I].x;
	float scaleY = scale[glfx_CURRENT_I].y;
	
	float cosA = rotate[glfx_CURRENT_I].x;
	float sinA = rotate[glfx_CURRENT_I].y;

	mat2 rotatingMatrix = mat2(cosA, sinA, -sinA, cosA);
	mat2 scalingMatrix = mat2(scaleX, 0, 0, scaleY);

	vec2 vertPos = attrib_pos.xy;
	vertPos = (vertPos * rotatingMatrix * scalingMatrix) + translating;

	gl_Position = vec4(vertPos, attrib_pos.z, 1.);

	// var_uv.x = gl_Position.x * 0.5 + 0.5;
	// var_uv.y = gl_Position.y * 0.5 + 1.;
	var_uv = attrib_uv;
}

#version 300 es

#define offset 0.0
#define bpm 120.0
#define str 0.4

#define zoomSpeed 0.15
#define zoomStr 1.0
#define zoomOffset 0.6

layout( location = 0 ) in vec3 attrib_pos;
layout( location = 3 ) in vec4 attrib_red_mask;

layout(std140) uniform glfx_GLOBAL
{
	mat4 glfx_MVP;
	mat4 glfx_PROJ;
	mat4 glfx_MV;
	vec4 glfx_QUAT;
};
layout(std140) uniform glfx_INSTANCES
{
	vec4 glfx_IDATA[8];
};
uniform uint glfx_CURRENT_I;
#define glfx_T_SPAWN (glfx_IDATA[glfx_CURRENT_I].x)
#define glfx_T_ANIM (glfx_IDATA[glfx_CURRENT_I].y)
#define glfx_ANIMKEY (glfx_IDATA[glfx_CURRENT_I].z)

out vec2 var_uv;
out float lut_str;


float defZoom(float x)
{
    return 1.+step(0.75,fract(x/4.));
}

void main()
{

	float aspect = glfx_PROJ[1][1]/glfx_PROJ[0][0];
	float s = sign(glfx_PROJ[0][0]);

	vec2 v = attrib_pos.xy;
	vec2 pos = v;
	float pulse = 0.0;
	vec2 uv = v*0.5 + 0.5;
	float time = (glfx_T_SPAWN + offset) * bpm / 60.0;
	float timeFrac = fract (time) * 7.0;
	float zoom = defZoom(time);
	if (timeFrac < 0.5) {
		pulse = smoothstep (0.0, 1.0, timeFrac*2.0)*str + 1.0;
	}
	else {
		pulse = smoothstep (0.0, 1.0, -timeFrac * 0.2 + 1.1)*str +1.0;
	}

	pos *= pulse * zoom;
	lut_str = pulse;

	gl_Position = vec4( pos, 0.5, 1.0 );
	var_uv = uv;
}
#version 300 es

#define UP_CORRECTION_COEFF 15.0

precision mediump sampler2DArray;

layout( location = 0 ) in vec3 attrib_pos;
layout( location = 3 ) in vec2 attrib_uv;
layout( location = 4 ) in uvec4 attrib_bones;

layout(std140) uniform glfx_GLOBAL
{
    mat4 glfx_MVP;
    mat4 glfx_PROJ;
    mat4 glfx_MV;
    vec4 unused;
    vec4 script_data;
};

uniform sampler2D glfx_BONES;

uniform sampler2D glfx_UVMORPH;
uniform sampler2D glfx_STATICPOS;

out vec2 var_bg_uv;
out vec2 var_uv;

mat3x4 get_bone( uint bone_idx )
{
    int b = int(bone_idx)*3;
    mat3x4 m = mat3x4( 
        texelFetch( glfx_BONES, ivec2(b,0), 0 ),
        texelFetch( glfx_BONES, ivec2(b+1,0), 0 ),
        texelFetch( glfx_BONES, ivec2(b+2,0), 0 ) );
    return m;
}

void main()
{
    float scale_coeff = script_data.x;
    mat3x4 m = get_bone( attrib_bones[0] );

    vec3 vpos = attrib_pos;

    vec2 flip_uv = vec2( attrib_uv.x, 1. - attrib_uv.y );
    vec3 translation = texture(glfx_UVMORPH,flip_uv).xyz;
    vpos += translation;

    vpos = vec4(vpos,1.)*m;

    mat4 mvp = glfx_MVP;

    vec4 uvmorphed_view = mvp * vec4( vpos, 1. );
    var_bg_uv = (uvmorphed_view.xy/uvmorphed_view.w)*0.5 + 0.5;

    vpos.y +=  (scale_coeff -1.0) * UP_CORRECTION_COEFF;
    vpos.x *= scale_coeff;
    vpos.y *= scale_coeff;
    gl_Position = mvp * vec4(vpos, 1.0);

    // vec4 uvmorphed_view = mvp * vec4( texture(glfx_STATICPOS,flip_uv).xyz + translation, 1. );
    // var_bg_uv = (uvmorphed_view.xy/uvmorphed_view.w)*0.5 + 0.5;

    var_uv = attrib_uv;
}
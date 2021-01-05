#version 300 es

#define TILE_SCALE 1.
#define TILE_ROTATE 0.
#define TILE_OFFSET 0., 0.
#define MESH_OFFSET_Z -110.

precision highp sampler2DArray;

layout( location = 0 ) in vec3 attrib_pos;
layout( location = 1 ) in vec3 attrib_n;
layout( location = 2 ) in vec4 attrib_t;
layout( location = 3 ) in vec2 attrib_uv;
layout( location = 4 ) in uvec4 attrib_bones;
layout( location = 5 ) in vec4 attrib_weights;

layout(std140) uniform glfx_GLOBAL
{
	mat4 glfx_MVP;
	mat4 glfx_PROJ;
	mat4 glfx_MV;
};
layout(std140) uniform glfx_INSTANCES
{
	vec4 glfx_IDATA[48];
};
uniform uint glfx_CURRENT_I;
#define glfx_T_SPAWN (glfx_IDATA[glfx_CURRENT_I].x)
#define glfx_T_ANIM (glfx_IDATA[glfx_CURRENT_I].y)
#define glfx_ANIMKEY (glfx_IDATA[glfx_CURRENT_I].z)

uniform sampler2D glfx_BONES;

out vec2 var_uv;
out vec2 var_bg_uv;

mat3x4 get_bone( uint bone_idx, int y, float t )
{
    ivec2 p = ivec2(int(bone_idx)*3,y);

    mat3x4 m = (1.-t)*mat3x4( 
        texelFetch( glfx_BONES, p, 0 ),
        texelFetchOffset( glfx_BONES, p, 0, ivec2(1,0) ),
        texelFetchOffset( glfx_BONES, p, 0, ivec2(2,0) ) );
    
    m += t*mat3x4( 
        texelFetchOffset( glfx_BONES, p, 0, ivec2(0,1) ),
        texelFetchOffset( glfx_BONES, p, 0, ivec2(1,1) ),
        texelFetchOffset( glfx_BONES, p, 0, ivec2(2,1) ) );
    
    return m;
}

mat3x4 get_transform()
{
    int y = int(glfx_ANIMKEY);
    float t = fract(glfx_ANIMKEY);
    mat3x4 m = get_bone( attrib_bones[0], y, t );
#ifndef GLFX_1_BONE
    if( attrib_weights[1] > 0. )
    {
        m = m*attrib_weights[0] + get_bone( attrib_bones[1], y, t )*attrib_weights[1];
        if( attrib_weights[2] > 0. )
        {
            m += get_bone( attrib_bones[2], y, t )*attrib_weights[2];
            if( attrib_weights[3] > 0. )
                m += get_bone( attrib_bones[3], y, t )*attrib_weights[3];
        }
    }
#endif

    return m;
}

void main()
{
    mat3x4 m = get_transform();

    vec3 vpos = vec4(attrib_pos,1.)*m;
    vec3 vnormal = vec4(attrib_n,0.)*m;

    vpos.xyz *= vec3(sign(glfx_PROJ[0][0])*1./360.,sign(glfx_PROJ[1][1])*1./640.,1./100.);

    gl_Position = vec4(vpos,1.);

    var_uv = attrib_uv;

    float s = sin(radians(TILE_ROTATE));
    float c = cos(radians(TILE_ROTATE));
    float a = glfx_PROJ[1][1]/glfx_PROJ[0][0];
    mat2 rot = mat2(a,0,0.,1.) * mat2(c,-s,s,c) * mat2(1./a,0,0.,1.);

    var_bg_uv = ((vpos.xy/TILE_SCALE)*rot)*0.5+0.5 + vec2(sign(glfx_PROJ[0][0]),sign(glfx_PROJ[1][1]))*vec2(TILE_OFFSET);

    float cosA = cos(radians(MESH_OFFSET_Z + 0.9 * glfx_ANIMKEY));
    float sinA = sin(radians(MESH_OFFSET_Z + 0.9 * glfx_ANIMKEY));
    vec2 offset = vec2(0.5 * (-cosA) - 0., 0.3 * (-sinA));
    var_bg_uv += vnormal.xy*0.01;
    var_bg_uv += offset;
}



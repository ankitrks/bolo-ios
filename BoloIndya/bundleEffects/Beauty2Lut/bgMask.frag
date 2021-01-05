#version 300 es

precision highp float;

in vec2 var_uv;

layout( location = 0 ) out vec4 F;

uniform sampler2D glfx_BACKGROUND;
uniform sampler2D bgMask;


void main()
{
    vec4 bgMaskColor = texture(bgMask, var_uv);

    if (bgMaskColor.r > 0.5)
    {
        F = texture(glfx_BACKGROUND, (var_uv * vec2 (2.0, 1.0) + vec2(0.0, 0.0)));
    } 
    else if (bgMaskColor.g > 0.5) 
    {
        F = texture(glfx_BACKGROUND, (var_uv * vec2 (2.0, 1.0) + vec2(-1.0, 0.0)));
    }
}

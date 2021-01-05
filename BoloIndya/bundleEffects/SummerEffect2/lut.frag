#version 300 es

precision highp float;

in vec2 var_uv;
in vec2 var_js_Resolution;

layout( location = 0 ) out vec4 F;

uniform sampler2D glfx_BACKGROUND;

void main()
{	
    discard;
    
    F = texture(glfx_BACKGROUND, var_uv);

    if (var_js_Resolution.x == 720.)
        F = vec4(1., 1., 1., 1.);
}

#version 300 es

precision highp float;

in vec2 var_uv;
in float var_touch_pos;
layout( location = 0 ) out vec4 F;

uniform sampler2D glfx_BACKGROUND;
uniform sampler2D lut1;
uniform sampler2D lut2;

vec4 finalColorFilter(vec4 orgColor, sampler2D lut)
{
    const float EPS = 0.000001;
    const float pxSize = 512.0;
    
    float bValue = (orgColor.b * 255.0) / 4.0;
    
    vec2 mulB = clamp(floor(bValue) + vec2(0.0, 1.0), 0.0, 63.0);
    vec2 row = floor(mulB / 8.0 + EPS);
    vec4 row_col = vec4(row, mulB - row * 8.0);
    vec4 lookup = orgColor.ggrr * (63.0/pxSize) + row_col * (64.0/pxSize) + (0.5/pxSize);
    
    float b1w = bValue - mulB.x;
    
	lookup*= pxSize;
	ivec4 positions = ivec4(lookup);

    vec3 sampled1 = texelFetch(lut, positions.zx, 0).rgb;
    vec3 sampled2 = texelFetch(lut, positions.wy, 0).rgb;
    
    vec3 res = mix(sampled1, sampled2, b1w);
    return vec4(res, orgColor.a);
}

void main()
{
    vec4 bg1 = texture(glfx_BACKGROUND, var_uv * vec2(0.5, 1.0));
    vec4 bg2 = texture(glfx_BACKGROUND, (var_uv + vec2(1.0, 0.0)) * vec2(0.5, 1.0));
    vec4 color1 = finalColorFilter(bg1, lut1);
    vec4 color2 = finalColorFilter(bg2, lut2);
    float div_pos = var_touch_pos;
    float divider = smoothstep(div_pos, div_pos, var_uv.x);
    F.xyz = mix(vec3(color2), vec3(color1), divider) * (divider * divider + (1.0 - divider) * (1.0 - divider));
    F.w = 1.0;
}

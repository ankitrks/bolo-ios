#version 300 es

precision mediump float;

in vec2 var_uv;
in vec2 var_bg_uv;

uniform sampler2D lut;
uniform sampler2D glfx_BACKGROUND;
uniform sampler2D opacity;

vec4 textureLookup(vec4 originalColor, sampler2D lookupTexture)
{
    const float epsilon = 0.000001;
    const float lutSize = 512.0;

    float blueValue = (originalColor.b * 255.0) / 4.0;

    vec2 mulB = clamp(floor(blueValue) + vec2(0.0, 1.0), 0.0, 63.0);
    vec2 row = floor(mulB / 8.0 + epsilon);
    vec4 row_col = vec4(row, mulB - row * 8.0);
    vec4 lookup = originalColor.ggrr * (63.0 / lutSize) + row_col * (64.0 / lutSize) + (0.5 / lutSize);

    float factor = blueValue - mulB.x;

    vec3 sampled1 = textureLod(lookupTexture, lookup.zx, 0.).rgb;
    vec3 sampled2 = textureLod(lookupTexture, lookup.wy, 0.).rgb;

    vec3 res = mix(sampled1, sampled2, factor);
    return vec4(res, originalColor.a);
}

layout( location = 0 ) out vec4 F;

void main()
{   
    vec3 rgb = textureLookup( texture( glfx_BACKGROUND, var_bg_uv ), lut ).xyz;
    float a = texture(opacity, var_uv).x;
	F = vec4(rgb, a);
}

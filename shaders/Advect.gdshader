shader_type canvas_item;
render_mode blend_disabled;

uniform highp vec2 texelSize;
uniform highp vec2 dyeTexelSize;
uniform highp sampler2D uVelocity;
uniform highp sampler2D uSource;
uniform highp float dt;
uniform highp float dissipation;

vec4 bilerp (sampler2D sam, vec2 uv, vec2 tsize) {
    vec2 st = uv / tsize - 0.5;

    vec2 iuv = floor(st);
    vec2 fuv = fract(st);
    vec4 a = texture(sam, (iuv + vec2(0.5, 0.5)) * tsize);
    vec4 b = texture(sam, (iuv + vec2(1.5, 0.5)) * tsize);
    vec4 c = texture(sam, (iuv + vec2(0.5, 1.5)) * tsize);
    vec4 d = texture(sam, (iuv + vec2(1.5, 1.5)) * tsize);
    return mix(mix(a, b, fuv.x), mix(c, d, fuv.x), fuv.y);
}

void fragment () {
    vec2 coord = UV - dt * texture(uVelocity, UV).xy * texelSize;
    vec4 result = texture(uSource, coord);
    float decay = 1.0 + dissipation * dt;
    COLOR = result / decay;
}
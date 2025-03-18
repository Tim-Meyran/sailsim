shader_type canvas_item;
render_mode blend_disabled;

uniform highp vec2 texelSize;
uniform highp vec2 dyeTexelSize;
uniform highp sampler2D uVelocity;
uniform highp sampler2D uSource;
uniform highp float dt;
uniform highp float dissipation;

uniform mediump float min_val;
uniform mediump float max_val;

vec4 map_value(vec4 v) {
    float x = clamp((v.x - min_val) / (max_val - min_val), 0.0, 1.0);
	float y = clamp((v.y - min_val) / (max_val - min_val), 0.0, 1.0);
	float z = clamp((v.z - min_val) / (max_val - min_val), 0.0, 1.0);
	return vec4(x,y,z,v.a);
}
vec4 textureScale(sampler2D tex,vec2 uv_coords) {
    vec4 tex_value = texture(tex, uv_coords);
    float x =  mix(min_val, max_val, tex_value.x);
	float y =  mix(min_val, max_val, tex_value.y); 
	float z =  mix(min_val, max_val, tex_value.z); 
	return vec4(x,y,z,tex_value.a);
}

vec4 bilerp (sampler2D sam, vec2 uv, vec2 tsize) {
    vec2 st = uv / tsize - 0.5;
    vec2 iuv = floor(st);
    vec2 fuv = fract(st);
    vec4 a = textureScale(sam, (iuv + vec2(0.5, 0.5)) * tsize);
    vec4 b = textureScale(sam, (iuv + vec2(1.5, 0.5)) * tsize);
    vec4 c = textureScale(sam, (iuv + vec2(0.5, 1.5)) * tsize);
    vec4 d = textureScale(sam, (iuv + vec2(1.5, 1.5)) * tsize);
    return mix(mix(a, b, fuv.x), mix(c, d, fuv.x), fuv.y);
}

void fragment () {
	/*vec2 coord = UV - dt * bilerp(uVelocity, UV, texelSize).xy * texelSize;
    vec4 result = bilerp(uSource, coord, dyeTexelSize);
    float decay = dissipation * dt;
    COLOR = map_value(result / decay);*/
	
	//COLOR = vec4(decay,0.0, 0.0, 1.0);
   vec2 coord = UV - dt * textureScale(uVelocity, UV).xy * texelSize;
    vec4 result = textureScale(uSource, coord);
    float decay = 1.0 + dissipation * dt;
    COLOR = map_value(result / decay);
}
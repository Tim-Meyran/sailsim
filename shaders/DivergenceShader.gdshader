shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D source_texture;
uniform highp vec2 texelSize;

varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;

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

void vertex(){
	vL = UV - vec2(texelSize.x, 0.0);
	vR = UV + vec2(texelSize.x, 0.0);
	vT = UV + vec2(0.0, texelSize.y);
	vB = UV - vec2(0.0, texelSize.y);
}

void fragment() {
	float L = textureScale(source_texture, vL).x;
	float R = textureScale(source_texture, vR).x;
	float T = textureScale(source_texture, vT).y;
	float B = textureScale(source_texture, vB).y;

	vec2 C = textureScale(source_texture, UV).xy;
	if (vL.x < 0.0) { L = -C.x; }
	if (vR.x > 1.0) { R = -C.x; }
	if (vT.y > 1.0) { T = -C.y; }
	if (vB.y < 0.0) { B = -C.y; }

	float div = 0.5 * (R - L + T - B);
	COLOR = map_value(vec4(div, 0.0, 0.0, 1.0));
}
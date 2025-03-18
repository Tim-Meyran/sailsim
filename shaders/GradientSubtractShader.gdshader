shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D uPressure;
uniform highp sampler2D uVelocity;

uniform highp vec2 texelSize;
uniform highp vec2 dyeTexelSize;
uniform highp float dt;
uniform highp float dissipation;

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
	float L = textureScale(uPressure, vL).x;
    float R = textureScale(uPressure, vR).x;
    float T = textureScale(uPressure, vT).x;
    float B = textureScale(uPressure, vB).x;
    vec2 velocity = textureScale(uVelocity, UV).xy;
    velocity.xy -= vec2(R - L, T - B);
    COLOR = map_value(vec4(velocity, 0.0, 1.0));
}
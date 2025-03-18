shader_type canvas_item;
render_mode blend_disabled;

varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;

uniform highp sampler2D uVelocity;
uniform highp vec2 texelSize;
uniform highp sampler2D uCurl;
uniform highp float curl;
uniform highp float dt;

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

void vertex () {
    vL = UV - vec2(texelSize.x, 0.0);
    vR = UV + vec2(texelSize.x, 0.0);
    vT = UV + vec2(0.0, texelSize.y);
    vB = UV - vec2(0.0, texelSize.y);
}

void fragment() {
	float L = textureScale(uCurl, vL).x;
    float R = textureScale(uCurl, vR).x;
    float T = textureScale(uCurl, vT).x;
    float B = textureScale(uCurl, vB).x;
    float C = textureScale(uCurl, UV).x;

    vec2 force = 0.5 * vec2(abs(T) - abs(B), abs(R) - abs(L));
    force /= length(force) + 0.0001;
    force *= curl * C;
    force.y *= -1.0;

    vec2 velocity = textureScale(uVelocity, UV).xy;
    velocity += force * dt;
    velocity = min(max(velocity, -1000.0), 1000.0);
    COLOR = map_value(vec4(velocity, 0.0, 1.0));
}
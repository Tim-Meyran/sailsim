shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D source_texture;

const vec2 vL = vec2(0.1,0.1);
const vec2 vR = vec2(0.1,0.1);

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
//Blur shader
void fragment () {
    vec4 sum = textureScale(source_texture, UV) * 0.29411764;
    //sum += textureScale(source_texture, vL) * 0.35294117;
    //sum += textureScale(source_texture, vR) * 0.35294117;
    COLOR = map_value(sum);
	//COLOR = texture(source_texture, UV);
}

shader_type canvas_item;
render_mode blend_disabled;

uniform sampler2D uSource;

uniform mediump float min_val;
uniform mediump float max_val;

vec4 map_value(vec4 value) {
    float x = clamp((value.x - min_val) / (max_val - min_val), 0.0, 1.0);
	float y = clamp((value.y - min_val) / (max_val - min_val), 0.0, 1.0);
	float z = clamp((value.z - min_val) / (max_val - min_val), 0.0, 1.0);
	return vec4(x,y,z,value.a);
}
vec4 textureScale(sampler2D tex,vec2 uv_coords) {
    vec4 tex_value = texture(tex, uv_coords);
    float x =  mix(min_val, max_val, tex_value.x);
	float y =  mix(min_val, max_val, tex_value.y); 
	float z =  mix(min_val, max_val, tex_value.z); 
	return vec4(x,y,z,tex_value.a);
}

void vertex() {
}

void fragment() {
	float x = 0.5 + 0.2 ;//* sin(TIME);
	float y = 0.5 + 0.2 ;//* cos(TIME);
		
	float width = 50.0f;
	float height = 50.0f;
	
	vec2 dir = vec2(
		0.5f + 0.5f*sin(2.0f*TIME),
		0.5f + 0.5f*cos(2.0f*TIME));

	COLOR = texture(uSource, UV);	
	if(distance(vec2(x,y),UV) < 0.05f){
		COLOR = map_value(vec4(dir.x,dir.y,0.0,1.0));
	}
}
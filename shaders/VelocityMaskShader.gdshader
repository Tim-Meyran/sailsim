shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D uSource1;
uniform highp sampler2D uSource2;

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

void fragment () {
  	vec4 val1 = texture(uSource1,UV);
	
	if(val1.a > 0.1){
		COLOR = val1;
	}else {
		COLOR = texture(uSource2,UV);
	}
	//COLOR = texture(uSource2,UV);
	//COLOR = vec4(0.1,0.0,0.0,1.0);
}
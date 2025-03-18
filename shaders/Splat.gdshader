shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D uTarget;
//uniform highp float aspectRatio;
uniform mediump vec3 color;
uniform mediump vec2 point;
uniform mediump float radius;
uniform mediump float clear;

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
	vec2 p = UV - point.xy;
	//p.x *= aspectRatio;
	vec3 splat = exp(-dot(p, p) / radius) * color;
	vec3 base = textureScale(uTarget, UV).xyz;
	//base = vec3(0,0,0);
	COLOR = map_value(vec4(base + splat, 1.0));

	float x = 0.5 + 0.5 * cos(TIME*1.0);
	float y = 0.5 + 0.5 * sin(TIME*1.0);
	
	if(x - 0.1 < UV.x && x + 0.1 > UV.x  && y - 0.1 < UV.y && y + 0.1 > UV.y  ){
		//COLOR = vec4(1.0,0.8,0.0,1.0);
	}
	if(clear < 0.5){
		COLOR = vec4(0.5,0.5,0.5,1.0);
	}
}
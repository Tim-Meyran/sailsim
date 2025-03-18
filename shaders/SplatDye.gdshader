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


void vertex() {

}

void fragment() {
	vec2 p = UV - point.xy;
	//p.x *= aspectRatio;
	vec3 splat = exp(-dot(p, p) / radius) * color;
	vec3 base = texture(uTarget, UV).xyz;
	//base = vec3(0,0,0);
	COLOR = vec4(base + splat, 1.0);

	if(clear < 0.5){
		COLOR = vec4(0.5,0.5,0.5,1.0);
	}
}
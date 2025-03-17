shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D uTarget;
//uniform highp float aspectRatio;
varying highp vec3 color;
varying highp vec2 point;
varying highp float radius;

void vertex() {
	color = vec3(500.0f,500.0f,0.0f);
	point = vec2(0.5f,0.5f);
	radius = 0.5;
}

void fragment() {
	vec2 p = UV - point.xy;
	//p.x *= aspectRatio;
	vec3 splat = exp(-dot(p, p) / radius) * color;
	vec3 base = texture(uTarget, UV).xyz;
	COLOR = vec4(base + splat, 1.0);
	//FRAGCOLOR = vec4(base, 1.0);
	//COLOR = vec4(-1.0f);
}
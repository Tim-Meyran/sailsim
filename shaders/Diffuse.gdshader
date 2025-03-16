shader_type canvas_item;

uniform highp sampler2D source_texture;
uniform highp vec2 texelSize;

varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;

void vertex(){
	vL = UV - vec2(texelSize.x, 0.0);
	vR = UV + vec2(texelSize.x, 0.0);
	vT = UV + vec2(0.0, texelSize.y);
	vB = UV - vec2(0.0, texelSize.y);
}

void fragment() {
	float L = texture(source_texture, vL).x;
	float R = texture(source_texture, vR).x;
	float T = texture(source_texture, vT).y;
	float B = texture(source_texture, vB).y;

	vec2 C = texture(source_texture, UV).xy;
	if (vL.x < 0.0) { L = -C.x; }
	if (vR.x > 1.0) { R = -C.x; }
	if (vT.y > 1.0) { T = -C.y; }
	if (vB.y < 0.0) { B = -C.y; }

	float div = 0.5 * (R - L + T - B);
	COLOR = vec4(div, 0.0, 0.0, 1.0);
}
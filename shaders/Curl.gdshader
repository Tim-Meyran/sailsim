shader_type canvas_item;

uniform highp sampler2D uVelocity;
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
	float L = texture(uVelocity, vL).y;
    float R = texture(uVelocity, vR).y;
    float T = texture(uVelocity, vT).x;
    float B = texture(uVelocity, vB).x;
    float vorticity = R - L - T + B;
    COLOR = vec4(0.5 * vorticity, 0.0, 0.0, 1.0);
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	
	//COLOR = texture(uVelocity, UV);
}
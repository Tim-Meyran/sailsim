shader_type canvas_item;

uniform highp sampler2D uPressure;
uniform highp sampler2D uDivergence;

uniform highp vec2 texelSize;
uniform highp vec2 dyeTexelSize;
uniform highp float dt;
uniform highp float dissipation;

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
	float L = texture(uPressure, vL).x;
    float R = texture(uPressure, vR).x;
    float T = texture(uPressure, vT).x;
    float B = texture(uPressure, vB).x;
    float C = texture(uPressure, UV).x;
    float divergence = texture(uDivergence, UV).x;
    float pressure = (L + R + B + T - divergence) * 0.25;
    COLOR = vec4(pressure, 0.0, 0.0, 1.0);
}
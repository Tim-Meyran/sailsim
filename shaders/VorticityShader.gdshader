shader_type canvas_item;

varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;

uniform highp sampler2D uVelocity;
uniform highp vec2 texelSize;
uniform highp sampler2D uCurl;
uniform highp float curl;
uniform highp float dt;

void vertex () {
    vL = UV - vec2(texelSize.x, 0.0);
    vR = UV + vec2(texelSize.x, 0.0);
    vT = UV + vec2(0.0, texelSize.y);
    vB = UV - vec2(0.0, texelSize.y);
}

void fragment() {
	float L = texture(uCurl, vL).x;
    float R = texture(uCurl, vR).x;
    float T = texture(uCurl, vT).x;
    float B = texture(uCurl, vB).x;
    float C = texture(uCurl, UV).x;

    vec2 force = 0.5 * vec2(abs(T) - abs(B), abs(R) - abs(L));
    force /= length(force) + 0.0001;
    force *= curl * C;
    force.y *= -1.0;

    vec2 velocity = texture(uVelocity, UV).xy;
    velocity += force * dt;
    velocity = min(max(velocity, -1000.0), 1000.0);
    COLOR = vec4(velocity, 0.0, 1.0);
}
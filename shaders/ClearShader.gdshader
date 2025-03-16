shader_type canvas_item;

uniform highp sampler2D uTexture;
uniform highp float value;

void fragment() {
 	COLOR = value * texture(uTexture, UV);
}
shader_type canvas_item;
render_mode blend_disabled;

uniform highp sampler2D uTexture;
uniform highp float value;

void fragment() {
 	COLOR = value * texture(uTexture, UV);
}
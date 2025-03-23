shader_type canvas_item;
render_mode blend_disabled;

uniform vec3 velocity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(velocity,1.0);
}
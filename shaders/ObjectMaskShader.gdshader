shader_type spatial;
render_mode unshaded;

uniform vec3 velocity;

void vertex() {
	// Called for every vertex the material is visible on.
}
// Called for every pixel the material is visible on.
void fragment() {
	ALBEDO = velocity;//vec3(0.0,0.0,1.0);	
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	//DIFFUSE_LIGHT = vec3(1.0,0.5,0.5);	
}

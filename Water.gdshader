shader_type canvas_item;

//uniform sampler2D albedo_texture: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec3 world_position = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//ALBEDO = vec3(0.5 + 0.5*sin(TIME + world_position.x),0.5 + 0.5*sin(TIME + world_position.z),0.5);

	//vec2 pos = UV;
	//pos.x = 0.5f + sin(TIME) / 2.1;
	//vec4 col = texture(albedo_texture, UV); // Read from texture again.
	
	COLOR = vec4(0.0,0.0,1.0,1.0);

}

/*void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	DIFFUSE_LIGHT = vec3(0.0);
}
*/
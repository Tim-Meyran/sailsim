shader_type canvas_item;
render_mode blend_disabled;

uniform sampler2D target_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
//#ALBEDO = vec3(1.0,0.0,0.0);
	COLOR = texture(target_texture,UV);
   	
	//COLOR = vec4(0.8,0.0,0.0,1.0);//vec4(sin(TIME + UV.x)*0.5+0.5, UV.y, 0.5, 1.0);
	float x = 0.5 + 0.5 * sin(TIME)*0.3;
	float y = 0.5 + 0.5 * cos(TIME)*0.25;
	
	if(x - 0.1 < UV.x && x + 0.1 > UV.x  && y - 0.1 < UV.y && y + 0.1 > UV.y  ){
		COLOR = vec4(0.3,0.7,0.5,1.0) * x;
		//COLOR = texture(target_texture,vec2(sin(UV.x + TIME*1.0)*0.5+0.5,UV.y));
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

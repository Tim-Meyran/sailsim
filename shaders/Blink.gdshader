shader_type canvas_item;

uniform sampler2D uSource;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float x = 0.5 + 0.2 * sin(TIME);
	float y = 0.5 + 0.2 * cos(TIME);
		
	float width = 50.0f;
	float height = 50.0f;
	
	vec2 dir = vec2(
		sin(-1.5f*TIME),
		cos(-1.5f*TIME));

	COLOR = texture(uSource, UV);	
	if(distance(vec2(x,y),UV) < 0.1f){
		COLOR = vec4(dir.x,dir.y,0.0,1.0);
	}
	
	if(false){
		COLOR = vec4(0.01,0.01,0.0,1.0);
	}
}
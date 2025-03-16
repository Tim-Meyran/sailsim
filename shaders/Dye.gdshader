shader_type canvas_item;

uniform sampler2D uSource;

void vertex() {
}

void fragment() {
	float x = 0.5 + 0.2 * sin(TIME);
	float y = 0.5 + 0.2 * cos(TIME);
		
	float width = 50.0f;
	float height = 50.0f;
	
	vec2 dir = vec2(
		0.5f + 0.5f*sin(2.0f*TIME),
		0.5f + 0.5f*cos(2.0f*TIME));

	COLOR = texture(uSource, UV);	
	if(distance(vec2(x,y),UV) < 0.05f){
		COLOR = vec4(dir.x,dir.y,0.0,1.0);
	}
}
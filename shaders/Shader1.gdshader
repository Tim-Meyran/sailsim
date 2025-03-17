shader_type canvas_item;
render_mode blend_disabled;
uniform highp sampler2D source_texture;

void fragment() {
	COLOR = texture(source_texture,UV);
	
	float x = 0.5 + 0.5 * cos(TIME*2.0);
	float y = 0.5 + 0.5 * sin(TIME*2.0);
	
	if(x - 0.1 < UV.x && x + 0.1 > UV.x  && y - 0.1 < UV.y && y + 0.1 > UV.y  ){
		COLOR = vec4(1.0,0.8,0.0,1.0);
	}
}
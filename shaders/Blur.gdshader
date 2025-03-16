shader_type canvas_item;
uniform highp sampler2D source_texture;

const vec2 vL = vec2(0.1,0.1);
const vec2 vR = vec2(0.1,0.1);

//Blur shader
void fragment () {
    //vec4 sum = texture(source_texture, UV) * 0.29411764;
    //sum += texture(source_texture, vL) * 0.35294117;
    //sum += texture(source_texture, vR) * 0.35294117;
    //COLOR = sum;
	COLOR = texture(source_texture, UV);
}

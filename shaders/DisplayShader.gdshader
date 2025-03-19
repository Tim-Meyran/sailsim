shader_type canvas_item;

varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;

uniform highp sampler2D uTexture;
/*uniform highp sampler2D uBloom;
uniform highp sampler2D uSunrays;
uniform highp sampler2D uDithering;*/

uniform highp vec2 ditherScale;
uniform highp vec2 texelSize;

uniform mediump float min_val;
uniform mediump float max_val;

vec4 map_value(vec4 v) {
    float x = clamp((v.x - min_val) / (max_val - min_val), 0.0, 1.0);
	float y = clamp((v.y - min_val) / (max_val - min_val), 0.0, 1.0);
	float z = clamp((v.z - min_val) / (max_val - min_val), 0.0, 1.0);
	return vec4(x,y,z,v.a);
}
vec4 textureScale(sampler2D tex,vec2 uv_coords) {
    vec4 tex_value = texture(tex, uv_coords);
    float x =  mix(min_val, max_val, tex_value.x);
	float y =  mix(min_val, max_val, tex_value.y); 
	float z =  mix(min_val, max_val, tex_value.z); 
	return vec4(x,y,z,tex_value.a);
}

vec3 linearToGamma (vec3 color) {
    color = max(color, vec3(0));
    return max(1.055 * pow(color, vec3(0.416666667)) - 0.055, vec3(0));
}

void vertex(){
	vL = UV - vec2(texelSize.x, 0.0);
	vR = UV + vec2(texelSize.x, 0.0);
	vT = UV + vec2(0.0, texelSize.y);
	vB = UV - vec2(0.0, texelSize.y);
}

void fragment() {
	vec3 c = textureScale(uTexture, UV).rgb;

	#define SHADING
	#ifdef SHADING
	    vec3 lc = textureScale(uTexture, vL).rgb;
	    vec3 rc = textureScale(uTexture, vR).rgb;
	    vec3 tc = textureScale(uTexture, vT).rgb;
	    vec3 bc = textureScale(uTexture, vB).rgb;

	    float dx = length(rc) - length(lc);
	    float dy = length(tc) - length(bc);

	    vec3 n = normalize(vec3(dx, dy, length(texelSize)));
	    vec3 l = vec3(0.0, 0.0, 1.0);

	    float diffuse = clamp(dot(n, l) + 0.7, 0.7, 1.0);
	    c *= diffuse;
	#endif

	#ifdef BLOOM
		vec3 bloom = texture(uBloom, vUv).rgb;
	#endif

	#ifdef SUNRAYS
		float sunrays = texture(uSunrays, vUv).r;
		c *= sunrays;
		#ifdef BLOOM
		bloom *= sunrays;
		#endif
	#endif

	#ifdef BLOOM
		float noise = texture(uDithering, vUv * ditherScale).r;
		noise = noise * 2.0 - 1.0;
		bloom += noise / 255.0;
		bloom = linearToGamma(bloom);
		c += bloom;
	#endif
	
	float a = max(c.r, max(c.g, c.b));
	COLOR = vec4(c, a);
	
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0);
}
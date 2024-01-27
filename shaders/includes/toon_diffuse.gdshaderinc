global uniform float SHADOW_ATTENUATION;

vec3 get_toon_diffuse(float attenuation, vec3 light_color) {
	float final_attenuation = attenuation < 1.0 ? SHADOW_ATTENUATION : 1.0;
	return  final_attenuation * light_color / PI;
}
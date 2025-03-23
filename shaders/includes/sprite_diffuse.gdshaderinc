global uniform float SHADOW_ATTENUATION;

vec3 get_sprite_diffuse(float attenuation, vec3 light_color) {
	float final_attenuation = 
			attenuation < SHADOW_ATTENUATION ? SHADOW_ATTENUATION : 1.0;
	return final_attenuation * light_color / PI;
}
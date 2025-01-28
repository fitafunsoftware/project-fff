#ifndef SHADOW_ATTENUATION_DEFINED
#define SHADOW_ATTENUATION_DEFINED
global uniform float SHADOW_ATTENUATION;
#endif

vec3 get_sprite_diffuse(float attenuation, vec3 light_color) {
	float final_attenuation = attenuation < 1.0 ? SHADOW_ATTENUATION : 1.0;
	return  final_attenuation * light_color / PI;
}
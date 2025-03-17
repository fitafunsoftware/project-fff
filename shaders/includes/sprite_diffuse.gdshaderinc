#ifndef SHADOW_ATTENUATION_DEFINED
#define SHADOW_ATTENUATION_DEFINED
global uniform float SHADOW_ATTENUATION;
#endif

const float max_additive_value = 1.0 / 3.0;
const float main_ratio = 2.0;
const float test_ratio = 4.0;
const float detail_ratio = 1.0;

vec3 get_sprite_diffuse(float attenuation, vec3 light_color) {
	float main_mult = main_ratio / (test_ratio + detail_ratio + main_ratio);
	float final_attenuation = attenuation < 1.0 ? SHADOW_ATTENUATION : 1.0;
	final_attenuation *= max_additive_value * main_mult;
	return  final_attenuation * light_color / PI;
}

vec3 get_test_diffuse(float attenuation, vec3 light_color) {
	float test_mult = test_ratio / (test_ratio + detail_ratio + main_ratio);
	vec3 true_light_color = vec3(light_color.g);
	float final_attenuation = attenuation * max_additive_value * test_mult;
	return final_attenuation * true_light_color / PI;
}

vec3 get_detail_diffuse(float attenuation, vec3 light_color) {
	float detail_mult = detail_ratio / (test_ratio + detail_ratio + main_ratio);
	vec3 true_light_color = vec3(light_color.b);
	float final_attenuation = attenuation * max_additive_value * detail_mult;
	return final_attenuation * true_light_color / PI;
}
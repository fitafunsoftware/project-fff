global uniform float SHADOW_ATTENUATION;

#include "uid://boulc4k1hm5o8"

uniform vec3 tint : source_color = vec3(1.0, 0.0, 0.0);

const float global_ratio = 2.0;
const float indicator_ratio = 4.0;
const float overall_ratio = 1.0;

const float max_additive_value = 1.0 / (sign(global_ratio) + sign(indicator_ratio) + sign(overall_ratio));
const float global_mult = global_ratio / (global_ratio + indicator_ratio + overall_ratio);
const float indicator_mult = indicator_ratio / (global_ratio + indicator_ratio + overall_ratio);
const float overall_mult = overall_ratio / (global_ratio + indicator_ratio + overall_ratio);

float get_final_attenuation(float attenuation, float mult) {
#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	float final_attenuation = attenuation < 1.0 ? 0.0 : 1.0;
	return final_attenuation * max_additive_value * mult;
#else
	float final_attenuation = attenuation < 1.0 ? SHADOW_ATTENUATION : 1.0;
	return final_attenuation;
#endif
}

vec3 get_global_diffuse(float attenuation, vec3 light_color) {
	return get_final_attenuation(attenuation, global_mult) * light_color / PI;
}

vec3 get_indicator_diffuse(float attenuation, vec3 light_color) {
	vec3 true_light_color = vec3(light_color.g);
	return get_final_attenuation(attenuation, indicator_mult) * true_light_color / PI;
}

vec3 get_overall_diffuse(float attenuation, vec3 light_color) {
	vec3 true_light_color = vec3(light_color.b);
	return get_final_attenuation(attenuation, overall_mult) * true_light_color / PI;
}

vec3 get_tint_diffuse(float attenuation) {
#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 no_tint = vec3(0.0);
#else
	vec3 no_tint = vec3(1.0);
#endif
	return attenuation < 0.99 ? tint : no_tint;
}

vec3 get_diffuse_light(float attenuation, vec3 light_color) {
	if (is_shadow_light(light_color)) {
		return get_tint_diffuse(attenuation);
	} else if(is_indicator_light(light_color)) {
		return get_indicator_diffuse(attenuation, light_color);
	} else if (is_overall_light(light_color)) {
		return get_overall_diffuse(attenuation, light_color);
	} else {
		return get_global_diffuse(attenuation, light_color);
	}
}
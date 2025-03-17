#ifndef SHADOW_ATTENUATION_DEFINED
#define SHADOW_ATTENUATION_DEFINED
global uniform float SHADOW_ATTENUATION;
#endif

uniform vec3 shadow_light_color : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 test_light_color : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 detail_light_color : source_color = vec3(0.0, 0.0, 1.0);
uniform vec3 tint : source_color = vec3(1.0, 0.0, 0.0);
const vec3 COLOR_ERROR_MARGIN = vec3(0.01);

bool is_shadow_light(vec3 light_color) {
	vec3 normalized_color = light_color/PI;
	bvec3 less_than = lessThan(normalized_color - COLOR_ERROR_MARGIN, shadow_light_color);
	bvec3 greater_than = greaterThan(normalized_color + COLOR_ERROR_MARGIN, shadow_light_color);
	return all(less_than) && all(greater_than);
}

bool is_test_light(vec3 light_color) {
	vec3 normalized_color = light_color/PI;
	bvec3 less_than = lessThan(normalized_color - COLOR_ERROR_MARGIN, test_light_color);
	bvec3 greater_than = greaterThan(normalized_color + COLOR_ERROR_MARGIN, test_light_color);
	return all(less_than) && all(greater_than);
}

bool is_detail_light(vec3 light_color) {
	vec3 normalized_color = light_color/PI;
	bvec3 less_than = lessThan(normalized_color - COLOR_ERROR_MARGIN, detail_light_color);
	bvec3 greater_than = greaterThan(normalized_color + COLOR_ERROR_MARGIN, detail_light_color);
	return all(less_than) && all(greater_than);
}

bool is_in_shadow(float attenuation) {
	return attenuation < 0.99;
}

vec3 get_tint_diffuse() {
	return tint;
}
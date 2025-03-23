uniform vec3 shadow_light_color : source_color = vec3(1.0, 0.0, 0.0);
const vec3 COLOR_ERROR_MARGIN = vec3(0.01);

bool is_color_equal(vec3 color, vec3 to_compare) {
	bvec3 less_than = lessThan(color - COLOR_ERROR_MARGIN, to_compare);
	bvec3 greater_than = greaterThan(color + COLOR_ERROR_MARGIN, to_compare);
	return all(less_than) && all(greater_than);
}

bool is_shadow_light(vec3 light_color) {
	vec3 normalized_color = abs(light_color)/PI;
	return is_color_equal(normalized_color, shadow_light_color);
}
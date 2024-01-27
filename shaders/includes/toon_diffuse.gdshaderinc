vec3 get_toon_diffuse(float attenuation, vec3 light_color) {
	return attenuation * light_color / PI;
}
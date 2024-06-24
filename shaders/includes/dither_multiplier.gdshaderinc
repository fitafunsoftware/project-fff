const mat4 BAYER_MATRIX = mat4(	vec4(-0.5, 0.0, -0.375, 0.125),
								vec4(0.25, -0.25, 0.375, -0.125),
								vec4(-0.3125, 0.1875, -0.4375, 0.0625),
								vec4(0.4375, -0.0625, 0.3125, -0.1875));

float get_dither_multiplier(vec2 pixel_position) {
	float bayer_value =
		BAYER_MATRIX[int(pixel_position.x/3.0) % 4][int(pixel_position.y/3.0) % 4];
	float bayer_output = 1.0 + (2.0 * bayer_value);
	float bayer_multiplier = min(bayer_output, 1.0);
	return bayer_multiplier;
}
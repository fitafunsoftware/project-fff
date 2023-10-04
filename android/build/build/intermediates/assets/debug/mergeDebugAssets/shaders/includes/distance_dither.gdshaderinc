const mat4 BAYER_MATRIX = mat4(	vec4(-0.5, 0.0, -0.375, 0.125),
								vec4(0.25, -0.25, 0.375, -0.125),
								vec4(-0.3125, 0.1875, -0.4375, 0.0625),
								vec4(0.4375, -0.0625, 0.3125, -0.1875));
#ifndef DISTANCE_SHADER_GLOBALS
global uniform float DISTANCE_FRONT_START;
global uniform float DISTANCE_FRONT_END;
global uniform float DISTANCE_BACK_START;
global uniform float DISTANCE_BACK_END;
#define DISTANCE_SHADER_GLOBALS
#endif
global uniform float DITHER_MULTIPLIER;
global uniform float DITHER_FULL_RATIO;

float get_dither_multiplier(float z, float camera_z, vec2 pixel_position) {
	float distance_to_camera = distance(z, camera_z);
	
	if (distance_to_camera >= DISTANCE_FRONT_START && distance_to_camera <= DISTANCE_BACK_START)
		return 1.0;
	
	if (distance_to_camera <= DISTANCE_FRONT_END || distance_to_camera >= DISTANCE_BACK_END)
		return 0.0;
	
	float bayer_value = BAYER_MATRIX[int(pixel_position.x) % 4][int(pixel_position.y) % 4];
	float bayer_output = 1.0 + 2.0*bayer_value;
	float bayer_multiplier = 1.0;
	
	if (bayer_output < 1.0)
		bayer_multiplier = DITHER_MULTIPLIER;
	
	float ratio = 1.0;
	
	if (distance_to_camera <= DISTANCE_FRONT_START) {
		float fade_length = DISTANCE_FRONT_START - DISTANCE_FRONT_END;
		float full_dither_end = DISTANCE_FRONT_END + fade_length * DITHER_FULL_RATIO;
		float dither_ratio_unnormalized = 
				(distance_to_camera - full_dither_end) / (fade_length*DITHER_FULL_RATIO);
		ratio = max(dither_ratio_unnormalized, 0.0);
	} else {
		float fade_length = DISTANCE_BACK_END - DISTANCE_BACK_START;
		float dither_ratio_unnormalized = 
				(distance_to_camera - DISTANCE_BACK_START) / (fade_length * DITHER_FULL_RATIO);
		ratio = 1.0 - min(dither_ratio_unnormalized, 1.0);
	}
	
	return mix(bayer_multiplier, 1.0, ratio);
}
const mat2 BAYER_MATRIX = mat2(	vec2(-0.5, 0.0),
								vec2(0.25, -0.25));
global uniform float FRONT_FADE_START_DISTANCE;
global uniform float FRONT_FADE_END_DISTANCE;
global uniform float BACK_FADE_START_DISTANCE;
global uniform float BACK_FADE_END_DISTANCE;
global uniform float DITHER_FULL_RATIO;

float get_fade_multiplier(float z, float camera_z, vec2 pixel_position) {
	float distance_to_camera = distance(z, camera_z);
	
	if (distance_to_camera >= FRONT_FADE_START_DISTANCE && distance_to_camera <= BACK_FADE_START_DISTANCE)
		return 1.0;
	
	if (distance_to_camera <= FRONT_FADE_END_DISTANCE || distance_to_camera >= BACK_FADE_END_DISTANCE)
		return 0.0;
	
	float bayer_value = BAYER_MATRIX[int(pixel_position.x) % 2][int(pixel_position.y) % 2];
	float bayer_output = 1.0 + 2.0*bayer_value;
	float bayer_multiplier = 1.0;
	
	if (bayer_output < 1.0)
		bayer_multiplier = 0.2;
	
	float ratio = 1.0;
	float dither_ratio = 1.0;
	
	if (distance_to_camera <= FRONT_FADE_START_DISTANCE) {
		float fade_length = FRONT_FADE_START_DISTANCE - FRONT_FADE_END_DISTANCE;
		ratio = (distance_to_camera - FRONT_FADE_END_DISTANCE) / fade_length;
		float full_dither_end = FRONT_FADE_END_DISTANCE + fade_length * DITHER_FULL_RATIO;
		float dither_ratio_unnormalized = 
				(distance_to_camera - full_dither_end) / (fade_length*DITHER_FULL_RATIO);
		dither_ratio = max(dither_ratio_unnormalized, 0.0);
	} else {
		float fade_length = BACK_FADE_END_DISTANCE - BACK_FADE_START_DISTANCE;
		ratio = (BACK_FADE_END_DISTANCE - distance_to_camera) / fade_length;
		float full_dither_start = BACK_FADE_START_DISTANCE + fade_length * DITHER_FULL_RATIO;
		float dither_ratio_unnormalized = 
				(distance_to_camera - BACK_FADE_START_DISTANCE) / (fade_length * DITHER_FULL_RATIO);
		dither_ratio = 1.0 - min(dither_ratio_unnormalized, 1.0);
	}
	
	return mix(0.0, 1.0, ratio) * mix(bayer_multiplier, 1.0, dither_ratio);
}
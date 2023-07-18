#ifndef DISTANCE_SHADER_GLOBALS
global uniform float DISTANCE_FRONT_START;
global uniform float DISTANCE_FRONT_END;
global uniform float DISTANCE_BACK_START;
global uniform float DISTANCE_BACK_END;
#define DISTANCE_SHADER_GLOBALS
#endif

float get_fade_multiplier(float z, float camera_z) {
	float distance_to_camera = distance(z, camera_z);
	
	if (distance_to_camera >= DISTANCE_FRONT_START && distance_to_camera <= DISTANCE_BACK_START)
		return 1.0;
	
	if (distance_to_camera <= DISTANCE_FRONT_END || distance_to_camera >= DISTANCE_BACK_END)
		return 0.0;
	
	float ratio = 1.0;
	
	if (distance_to_camera <= DISTANCE_FRONT_START) {
		float fade_length = DISTANCE_FRONT_START - DISTANCE_FRONT_END;
		ratio = (distance_to_camera - DISTANCE_FRONT_END) / fade_length;
	} else {
		float fade_length = DISTANCE_BACK_END - DISTANCE_BACK_START;
		ratio = (DISTANCE_BACK_END - distance_to_camera) / fade_length;
	}
	
	return mix(0.0, 1.0, ratio);
}
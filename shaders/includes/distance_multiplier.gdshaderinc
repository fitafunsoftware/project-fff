global uniform float DISTANCE_FRONT_START;
global uniform float DISTANCE_FRONT_END;
global uniform float DISTANCE_BACK_START;
global uniform float DISTANCE_BACK_END;

float get_distance_multiplier(float z, float camera_z) {
	float distance_to_camera = distance(z, camera_z);

	if (distance_to_camera >= DISTANCE_FRONT_START
			&& distance_to_camera <= DISTANCE_BACK_START)
		return 1.0;

	if (distance_to_camera <= DISTANCE_FRONT_END
			|| distance_to_camera >= DISTANCE_BACK_END)
		return 0.0;

	bool fade_from_front = distance_to_camera <= DISTANCE_FRONT_START;
	float front_fade_length = DISTANCE_FRONT_START - DISTANCE_FRONT_END;
	float back_fade_length = DISTANCE_BACK_END - DISTANCE_BACK_START;
	
	float ratio = fade_from_front ?
			(distance_to_camera - DISTANCE_FRONT_END)/front_fade_length :
			(DISTANCE_BACK_END - distance_to_camera)/back_fade_length;

	return ratio;
}
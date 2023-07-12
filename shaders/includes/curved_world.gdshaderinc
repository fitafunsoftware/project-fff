global uniform float CAMERA_Y_OFFSET;
global uniform float CAMERA_Z_OFFSET;
global uniform float CURVE_HEIGHT;
global uniform float CURVE_HEIGHT_RATIO;

float get_curved_y(float z, float camera_z) {
	float new_y = 0.0;
	
	if (!(CURVE_HEIGHT_RATIO > 0.0 && CURVE_HEIGHT_RATIO <= 1.0))
		return new_y;
	
	if (CURVE_HEIGHT <= 0.0)
		return new_y;
	
	// Following equations used to eliminate trigonometric functions
	float RADIUS = CURVE_HEIGHT/CURVE_HEIGHT_RATIO;
	float ARC_HEIGHT = RADIUS - CURVE_HEIGHT;
	float ARC_LENGTH = sqrt(pow(RADIUS, 2.0) - pow(ARC_HEIGHT, 2.0));
	float FLOOR_GRADIENT = ARC_LENGTH/ARC_HEIGHT;
	
	float curve_start = camera_z - CAMERA_Z_OFFSET - ARC_LENGTH;
	float curve_peak = camera_z - CAMERA_Z_OFFSET;
	float curve_end = camera_z - CAMERA_Z_OFFSET + ARC_LENGTH;
	
	if (z <= curve_start) {
		float z_offset = z - curve_start;
		float y_offset = z_offset*FLOOR_GRADIENT;
		new_y = CAMERA_Y_OFFSET + y_offset;
	}
	
	if (curve_start < z && z <= curve_peak) {
		float d = curve_peak - z;
		float y_total_offset = sqrt(pow(RADIUS, 2.0) - pow(d, 2.0));
		float y_offset = y_total_offset - ARC_HEIGHT;
		new_y = CAMERA_Y_OFFSET + y_offset;
	}
	
	if (curve_peak < z && z <= curve_end) {
		float d = z - curve_peak;
		float y_total_offset = sqrt(pow(RADIUS, 2.0) - pow(d, 2.0));
		float y_offset = y_total_offset - ARC_HEIGHT;
		new_y = CAMERA_Y_OFFSET + y_offset;
	}
	
	if (z > curve_end) {
		float z_offset = curve_end - z;
		float y_offset = z_offset*FLOOR_GRADIENT;
		new_y = CAMERA_Y_OFFSET + y_offset;
	}
	
	return new_y;
}
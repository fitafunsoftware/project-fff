global uniform float CAMERA_Y_OFFSET;
global uniform float CAMERA_Z_OFFSET;
global uniform float CURVE_HEIGHT;
global uniform float CURVE_HEIGHT_RATIO;

float get_curved_y(float z, float camera_z) {
	float y_offset = CAMERA_Y_OFFSET;
	
	if (!(CURVE_HEIGHT_RATIO > 0.0 && CURVE_HEIGHT_RATIO <= 1.0))
		return y_offset;
	
	if (CURVE_HEIGHT <= 0.0)
		return y_offset;
	
	// Following equations used to eliminate trigonometric functions
	float RADIUS = CURVE_HEIGHT/CURVE_HEIGHT_RATIO;
	float ARC_HEIGHT = RADIUS - CURVE_HEIGHT;
	float ARC_LENGTH = sqrt(pow(RADIUS, 2.0) - pow(ARC_HEIGHT, 2.0));
	float FLOOR_GRADIENT = -ARC_LENGTH/ARC_HEIGHT;
	
	float peak = camera_z - CAMERA_Z_OFFSET;
	float distance_from_peak = distance(z, peak);
	bool on_arc = distance_from_peak < ARC_LENGTH;
	
	// if on slope
	float offset = distance_from_peak - ARC_LENGTH;
	float curve_offset_on_slope = offset*FLOOR_GRADIENT;
	// endif
	
	// if on arc
	float circle_height = sqrt(pow(RADIUS, 2.0) - pow(distance_from_peak, 2.0));
	float curve_offset_on_arc = circle_height - ARC_HEIGHT;
	// endif
	
	// Rely on compiler to optimize this.
	y_offset += on_arc ? curve_offset_on_arc : curve_offset_on_slope;
	
	return y_offset;
}
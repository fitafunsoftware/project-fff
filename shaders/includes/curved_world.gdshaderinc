global uniform float CAMERA_Y_OFFSET;
global uniform float CAMERA_Z_OFFSET;
global uniform float RADIUS;
global uniform float DISTANCE_TO_CHORD;
global uniform float HALF_CHORD_LENGTH;
global uniform float FLOOR_GRADIENT;

float get_curved_y(float z, float camera_z) {
	if (!(RADIUS > 0.0)) return 0.0;
	float y_offset = CAMERA_Y_OFFSET;
	
	float peak = camera_z - CAMERA_Z_OFFSET;
	float distance_from_peak = distance(z, peak);
	bool on_arc = distance_from_peak < HALF_CHORD_LENGTH;
	
	// if on slope
	float offset = distance_from_peak - HALF_CHORD_LENGTH;
	float curve_offset_on_slope = offset*-FLOOR_GRADIENT;
	// endif
	
	// if on arc
	float circle_height = sqrt(pow(RADIUS, 2.0) - pow(distance_from_peak, 2.0));
	float curve_offset_on_arc = circle_height - DISTANCE_TO_CHORD;
	// endif
	
	// Rely on compiler to optimize this.
	y_offset += on_arc ? curve_offset_on_arc : curve_offset_on_slope;
	
	return y_offset;
}
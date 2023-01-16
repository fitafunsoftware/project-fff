shader_type spatial;

const float CAMERA_Y_OFFSET = -0.25;
const float CAMERA_Z_OFFSET = 20.0;
const float CURVE_HEIGHT = 0.75;
const float FLOOR_ANGLE = 0.5236;

const float MAX_ANGLE = 1.109;
const float COMPLEMENTARY_ANGLE = 0.4618;

uniform sampler2D texture_albedo;

float get_new_y(float z, float camera_z) {
	float CURVE_RADIUS = CURVE_HEIGHT/0.1;
	float CURVE_LENGTH = CURVE_RADIUS*0.45;
	float CURVE_L = MAX_ANGLE*CURVE_RADIUS;
	float COMPLEMENTARY_HEIGHT = CURVE_RADIUS - CURVE_HEIGHT;
	
	float new_y = 0.0;
	
	float curve_start = camera_z - CAMERA_Z_OFFSET - CURVE_LENGTH;
	float curve_peak = camera_z - CAMERA_Z_OFFSET;
	float curve_end = camera_z - CAMERA_Z_OFFSET + CURVE_LENGTH;
	
	if (z <= curve_start) {
		float z_offset = z - curve_start;
		float y_offset = z_offset*sin(FLOOR_ANGLE);
		new_y = y_offset + CAMERA_Y_OFFSET;
	}
	
	if (curve_start < z && z <= curve_peak) {
		float d = curve_peak - z;
		float theta = (d/CURVE_L)*(MAX_ANGLE);
		float y_offset = CURVE_RADIUS - CURVE_RADIUS*cos(theta);
		new_y = CAMERA_Y_OFFSET + CURVE_HEIGHT - y_offset;
	}
	
	if (curve_peak < z && z <= curve_end) {
		float d = z - curve_peak;
		float theta = (d/CURVE_L)*(MAX_ANGLE);
		float y_offset = CURVE_RADIUS - CURVE_RADIUS*cos(theta);
		new_y = CAMERA_Y_OFFSET + CURVE_HEIGHT - y_offset;
	}
	
	if (z > curve_end) {
		float z_offset = curve_end - z;
		float y_offset = z_offset*sin(FLOOR_ANGLE);
		new_y = y_offset + CAMERA_Y_OFFSET;
	}
	
	return new_y;
}

void vertex() {
	float world_z = (WORLD_MATRIX * vec4(VERTEX, 1.0)).z;
	float camera_z = (CAMERA_MATRIX * vec4(vec3(0.0), 1.0)).z;
	VERTEX.y += get_new_y(world_z, camera_z);
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
}
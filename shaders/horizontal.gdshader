shader_type spatial;
render_mode blend_mix,diffuse_toon,specular_disabled;

global uniform float CAMERA_Y_OFFSET;
global uniform float CAMERA_Z_OFFSET;
global uniform float CURVE_HEIGHT;
global uniform float FLOOR_ANGLE;
global uniform float MAX_ANGLE;

uniform sampler2D sprite_texture : source_color, filter_nearest;

float get_new_y(float z, float camera_z) {
	float CURVE_RADIUS = CURVE_HEIGHT/0.1;
	float CURVE_LENGTH = CURVE_RADIUS*0.45;
	float CURVE_L = MAX_ANGLE*CURVE_RADIUS;
	
	float new_y = 0.0;
	
	float curve_start = camera_z - CAMERA_Z_OFFSET - CURVE_LENGTH;
	float curve_peak = camera_z - CAMERA_Z_OFFSET;
	float curve_end = camera_z - CAMERA_Z_OFFSET + CURVE_LENGTH;
	
	if (z <= curve_start) 
	{
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
	vec4 world = (MODEL_MATRIX * vec4(VERTEX, 1.0));
	VERTEX.y += get_new_y(world.z, CAMERA_POSITION_WORLD.z);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	vec4 color = texture(sprite_texture,UV);
	ALBEDO = color.rgb;
}
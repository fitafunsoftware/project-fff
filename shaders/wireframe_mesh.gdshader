shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords,unshaded,wireframe;

#include "includes/curved_world.gdshaderinc"

uniform vec3 color : source_color;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	ALBEDO = color;
}

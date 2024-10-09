shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "includes/curved_world.gdshaderinc"
#include "includes/sprite_diffuse.gdshaderinc"

uniform vec4 color : source_color;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	ALBEDO = color.rgb;
	ALPHA = color.a;
}

void light() {
	DIFFUSE_LIGHT += get_sprite_diffuse(1.0, LIGHT_COLOR);
}

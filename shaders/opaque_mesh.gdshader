shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "includes/curved_world.gdshaderinc"
#include "includes/toon_diffuse.gdshaderinc"

uniform sampler2D sprite_texture : source_color, filter_nearest;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	vec4 color = texture(sprite_texture,UV);
	ALBEDO = color.rgb;
}

void light() {
	DIFFUSE_LIGHT += get_toon_diffuse(ATTENUATION, LIGHT_COLOR);
}
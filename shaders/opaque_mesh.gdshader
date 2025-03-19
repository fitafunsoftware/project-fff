shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords,ambient_light_disabled;

#include "uid://bdsoodic2nyyb"
#include "uid://bjjy0u5on1c51"

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
	vec3 diffuse_light = get_diffuse_light(ATTENUATION, LIGHT_COLOR);
#if CURRENT_RENDERER != RENDERER_COMPATIBILITY
	if (is_shadow_light(LIGHT_COLOR))
		DIFFUSE_LIGHT *= diffuse_light;
	else
#endif
	DIFFUSE_LIGHT += diffuse_light;
}
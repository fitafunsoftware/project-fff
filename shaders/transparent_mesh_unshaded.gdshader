shader_type spatial;
render_mode blend_mix,world_vertex_coords;

#include "includes/curved_world.gdshaderinc"
#include "includes/distance_fade.gdshaderinc"
#include "includes/distance_dither.gdshaderinc"
#include "includes/toon_diffuse.gdshaderinc"

uniform sampler2D sprite_texture : source_color, filter_nearest, repeat_disable;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	vec4 color = texture(sprite_texture, UV);
	vec2 pixel_position = UV * vec2(textureSize(sprite_texture, 0));
	float fade_multiplier = get_fade_multiplier(NODE_POSITION_WORLD.z, CAMERA_POSITION_WORLD.z);
	float dither_multiplier = get_dither_multiplier(NODE_POSITION_WORLD.z, CAMERA_POSITION_WORLD.z, pixel_position);
	
	ALBEDO = fade_multiplier >= 1.0 ?
		color.rgb : mix(vec3(0.02), color.rgb, fade_multiplier * dither_multiplier);
	ALPHA = min(fade_multiplier*dither_multiplier/DITHER_FULL_RATIO, 1.0)*opacity*color.a;
}

void light() {
	DIFFUSE_LIGHT += get_toon_diffuse(1.0, LIGHT_COLOR);
}
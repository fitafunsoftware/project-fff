shader_type spatial;
render_mode blend_mix,diffuse_toon,specular_disabled,world_vertex_coords;

#include "includes/curved_world.gdshaderinc"
#include "includes/distance_fade.gdshaderinc"
#include "includes/distance_dither.gdshaderinc"

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
	vec4 color = texture(sprite_texture, UV);
	vec2 pixel_position = UV * vec2(textureSize(sprite_texture, 0));
	float fade_multiplier = get_fade_multiplier(NODE_POSITION_WORLD.z, CAMERA_POSITION_WORLD.z);
	float dither_multiplier = get_dither_multiplier(NODE_POSITION_WORLD.z, CAMERA_POSITION_WORLD.z, pixel_position);
	
	if (fade_multiplier >= 1.0)
		ALBEDO = color.rgb;
	else
		ALBEDO = mix(vec3(0.0), color.rgb, fade_multiplier * dither_multiplier);
	ALPHA = min(fade_multiplier*dither_multiplier/DITHER_FULL_RATIO, 1.0)*color.a;
}
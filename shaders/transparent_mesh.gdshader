shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "includes/curved_world.gdshaderinc"
#include "includes/distance_multiplier.gdshaderinc"
#include "includes/dither_multiplier.gdshaderinc"
#include "includes/sprite_diffuse.gdshaderinc"

global uniform float DITHER_SCALE_EXPONENT;
global uniform float MAX_DITHER_RATIO;

uniform sampler2D sprite_texture : source_color, filter_nearest, repeat_disable;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform bool shaded = true;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
	
	// This is a hack. Please ignore.
	if (NODE_POSITION_WORLD.y > VERTEX.y)
		VERTEX.y = NODE_POSITION_WORLD.y;
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	vec4 color = texture(sprite_texture, UV);
	vec2 pixel_position = UV * vec2(textureSize(sprite_texture, 0));
	float distance_multiplier = sqrt(get_distance_multiplier(NODE_POSITION_WORLD.z, CAMERA_POSITION_WORLD.z));
	float dither_multiplier = get_dither_multiplier(pixel_position);
	dither_multiplier = MAX_DITHER_RATIO * dither_multiplier;
	float final_dither = mix(dither_multiplier, 1.0, distance_multiplier * opacity);
	final_dither = pow(final_dither, DITHER_SCALE_EXPONENT);
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
	if (opacity < 1.0) {
		ALBEDO *= (1.0 - final_dither);
		ALPHA *= final_dither * opacity;
	} else if (distance_multiplier < 1.0) {
		ALBEDO *= final_dither;
		ALPHA *= distance_multiplier;
	}
}

void light() {
	float attenuation = shaded ? ATTENUATION : 1.0;
	DIFFUSE_LIGHT += get_sprite_diffuse(attenuation, LIGHT_COLOR);
}
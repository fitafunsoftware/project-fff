shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "uid://bdsoodic2nyyb"
#include "uid://bjjy0u5on1c51"
#include "uid://boulc4k1hm5o8"

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
	if (is_shadow_light(LIGHT_COLOR)) {
		if (is_in_shadow(ATTENUATION)){
			DIFFUSE_LIGHT += get_tint_diffuse();
		}
	} else if (is_test_light(LIGHT_COLOR)) {
		if (!is_in_shadow(ATTENUATION)) {
			DIFFUSE_LIGHT += get_test_diffuse(ATTENUATION, LIGHT_COLOR);
		}
	} else if (is_detail_light(LIGHT_COLOR)) {
		if (!is_in_shadow(ATTENUATION)) {
			DIFFUSE_LIGHT += get_detail_diffuse(ATTENUATION, LIGHT_COLOR);
		}
	} else {
		DIFFUSE_LIGHT += get_sprite_diffuse(ATTENUATION, LIGHT_COLOR);
	}
}

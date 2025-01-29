shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "uid://bdsoodic2nyyb"
#include "uid://bjjy0u5on1c51"
#include "uid://boulc4k1hm5o8"

uniform sampler2D sprite_texture : source_color, filter_nearest, repeat_enable;
uniform float columns = 1.0;
uniform float rows = 1.0;
uniform sampler2D bitmap_texture : filter_nearest, hint_default_transparent;
uniform vec3 top_most;

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	float row = (NODE_POSITION_WORLD.z - top_most.z) / top_most.x;
	int x_size = textureSize(sprite_texture, 0).x;
	float floor_half_size = float(x_size / 2) / float(x_size);
	float row_offset = mod(row * rows, 2.0) * floor_half_size;
	vec4 color = texture(sprite_texture, vec2(UV.x * columns + row_offset, UV.y));
	vec4 bitmap = texture(bitmap_texture, vec2(UV.x + row_offset/columns, row));
	ALBEDO = color.rgb;
	ALPHA = color.a * bitmap.a;
}

void light() {
	if (is_shadow_light(LIGHT_COLOR)) {
		if (is_in_shadow(ATTENUATION)){
			DIFFUSE_LIGHT *= get_tint_diffuse();
		}
	} else {
		DIFFUSE_LIGHT += get_sprite_diffuse(ATTENUATION, LIGHT_COLOR);
	}
}
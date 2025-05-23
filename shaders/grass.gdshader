shader_type spatial;
render_mode blend_mix,specular_disabled,world_vertex_coords;

#include "uid://bdsoodic2nyyb"
#include "uid://bjjy0u5on1c51"

uniform sampler2D sprite_texture : source_color, filter_nearest, repeat_enable;
uniform sampler2D bitmap_texture : filter_nearest, hint_default_transparent;
uniform vec2 grid; // (rows, columns)
uniform vec2 row_info; // (total row length, z position of top most grass instance in global space)

void vertex() {
	float y_offset = get_curved_y(VERTEX.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}

	// Assigning columns to a float avoids low percision errors that cause
	// some devices to incorrectly render grass. Inlining the type cast also
	// fixes the problem, but this looks nicer.
	float columns = grid.y;
	lowp float row_percent = (NODE_POSITION_WORLD.z - row_info.y)/row_info.x;
	lowp float x_size = float(textureSize(sprite_texture, 0).x);
	lowp float floor_half_size = floor(x_size/2.0)/x_size;
	lowp float row_offset = mod(row_percent*grid.x, 2.0)*floor_half_size;

	vec4 color = texture(sprite_texture, vec2(UV.x*columns + row_offset, UV.y));
	vec4 bitmap = texture(bitmap_texture, vec2(UV.x + row_offset/columns, row_percent));
	ALBEDO = color.rgb;
	ALPHA = color.a * bitmap.a;
}

void light() {
	DIFFUSE_LIGHT += get_sprite_diffuse(ATTENUATION, LIGHT_COLOR);
}
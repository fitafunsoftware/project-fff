shader_type spatial;
render_mode blend_mix,diffuse_toon,specular_disabled;

#include "includes/curved_world.gdshaderinc"

uniform sampler2D sprite_texture : source_color, filter_nearest;

void vertex() {
	vec4 world = (MODEL_MATRIX * vec4(VERTEX, 1.0));
	float y_offset = get_curved_y(world.z, CAMERA_POSITION_WORLD.z);
	vec3 final_position = VERTEX + vec3(0.0, y_offset, 0.0);
	POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(final_position, 1.0);
}

void fragment() {
	if (!FRONT_FACING) {
		discard;
	}
	vec4 color = texture(sprite_texture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
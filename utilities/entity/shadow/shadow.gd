@tool
class_name Shadow3D
extends Sprite3D
## Node for Shadow Sprites.
##
## I am just lazy and made this to easily set these values when creating the node


func _init():
	double_sided = false
	alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY


func _ready():
	if Engine.is_editor_hint():
		return
	scale.z /= GlobalParams.get_global_param("FLOOR_GRADIENT")

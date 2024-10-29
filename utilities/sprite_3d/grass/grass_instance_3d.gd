@tool
class_name GrassInstance3D
extends MeshInstance3D
## Grass meshes.
##
## A specific mesh for grass cause we do not need the extra functionality
## provided by [VerticalSprite3D]s.

## The occluder that determines whether to show or hide the node.
var occluder: Occluder

# The current camera.
@onready var _current_camera: Camera3D = get_viewport().get_camera_3d()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _process(_delta: float):
	if not Engine.is_editor_hint():
		_occlude()


# Handle occlusion.
func _occlude():
	if not _current_camera.current:
		_current_camera = get_viewport().get_camera_3d()
	
	var camera_position: Vector3 = _current_camera.global_position
	if occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()

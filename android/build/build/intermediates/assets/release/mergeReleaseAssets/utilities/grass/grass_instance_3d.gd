@tool
class_name GrassInstance3D
extends MeshInstance3D

var occluder : Occluder

@onready var current_camera : Camera3D = get_viewport().get_camera_3d()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _process(_delta):
	if not Engine.is_editor_hint():
		_occlude()


func _occlude():
	if not current_camera.current:
		current_camera = get_viewport().get_camera_3d()
	
	var camera_position = current_camera.global_position
	if occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()


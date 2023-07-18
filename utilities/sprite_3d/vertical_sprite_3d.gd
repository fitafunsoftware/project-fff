@tool
extends Sprite3D
class_name VerticalSprite3D

@onready var occluder : Occluder = Occluder.new()
@onready var current_camera : Camera3D = get_viewport().get_camera_3d()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _ready() -> void:
	if not material_override:
		_apply_material_override()
	
	_apply_texture()
	texture_changed.connect(_apply_texture)


func _process(_delta):
	if not Engine.is_editor_hint():
		_occlude()


func _apply_material_override():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/transparent_mesh.gdshader")
	
	material_override = shader_material


func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
	
	occluder.set_height(texture.get_size().y * pixel_size)


func _occlude():
	if not current_camera.current:
		current_camera = get_viewport().get_camera_3d()
	
	var camera_position = current_camera.global_position
	if occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()

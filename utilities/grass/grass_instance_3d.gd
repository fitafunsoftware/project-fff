@tool
extends MeshInstance3D
class_name GrassInstance3D

@export var sprite_texture : Texture2D :
	set(value):
		sprite_texture = value
		_set_texture()

@export var size : Vector2 = Vector2.ZERO :
	set(value):
		size = value
		_set_size()

@export var sprites_per_row : int = 0 :
	set(value):
		sprites_per_row = value
		_set_sprites_per_row()

@export var bitmap : Texture2D :
	set(value):
		bitmap = value
		_set_bitmap()

var occluder : Occluder

@onready var current_camera : Camera3D = get_viewport().get_camera_3d()


func _init():
	if not mesh:
		var new_mesh := PlaneMesh.new()
		new_mesh.orientation = PlaneMesh.FACE_Z
		mesh = new_mesh
	
	if not mesh.material:
		var shader_material := ShaderMaterial.new()
		shader_material.shader = load("res://shaders/grass.gdshader")
		mesh.material = shader_material


func _process(_delta):
	_occlude()


func _occlude():
	if not current_camera.current:
		current_camera = get_viewport().get_camera_3d()
	
	var camera_position = current_camera.global_position
	if occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()


func _set_texture():
	if not sprite_texture:
		return
	
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprite_texture", sprite_texture)


func _set_size():
	var plane_mesh : PlaneMesh = mesh
	plane_mesh.size = size
	plane_mesh.center_offset = Vector3(0.0, size.y/2.0, 0.0)


func _set_sprites_per_row():
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprites_per_row", float(sprites_per_row))


func _set_bitmap():
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("bitmap", bitmap)

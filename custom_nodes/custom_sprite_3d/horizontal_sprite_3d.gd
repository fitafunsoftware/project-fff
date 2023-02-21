@tool
extends MeshInstance3D
class_name HorizontalSprite3D

@export var texture : Texture2D:
	set(value):
		texture = value
		_recalculate_size_and_subdivisions()
		_apply_texture()

@export_range(0.001, 128, 0.001, "suffix:m") var pixel_size : float = 0.01:
	set(value):
		pixel_size = value
		_recalculate_size_and_subdivisions()

@export var subdivisions_per_meter : int = 1:
	set(value):
		subdivisions_per_meter = value
		_recalculate_subdivisions()


func _ready():
	if not mesh:
		mesh = PlaneMesh.new()
		mesh.orientation = PlaneMesh.FACE_Y
		_recalculate_size_and_subdivisions()
	
	if not mesh.material:
		var shader_material := ShaderMaterial.new()
		shader_material.shader = load("res://shaders/horizontal.gdshader")
		mesh.material = shader_material
		_apply_texture()


func _recalculate_size_and_subdivisions():
	if not mesh:
		return
	
	if not texture:
		mesh.size = Vector2(1, 1)
	else:
		mesh.size = texture.get_size() * pixel_size
	
	var floor_angle : float = GlobalParams.get_global_shader_param("FLOOR_ANGLE");
	mesh.size.y /= sin(floor_angle)
	
	_recalculate_subdivisions()


func _recalculate_subdivisions():
	if not mesh:
		return
	
	mesh.subdivide_depth = roundi(mesh.size.y * subdivisions_per_meter)


func _apply_texture():
	if not mesh:
		return
	
	if not mesh.material:
		return
	
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprite_texture", texture)

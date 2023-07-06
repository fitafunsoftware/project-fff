@tool
extends MeshInstance3D
class_name HorizontalSprite3D

static var FLOOR_ANGLE : float = NAN

@export var texture : Texture2D:
	set(value):
		texture = value
		_recalculate_size_and_subdivisions()
		_apply_texture()

@export_range(0.001, 128, 0.001, "suffix:m") var pixel_size : float = 0.01:
	set(value):
		pixel_size = value
		_recalculate_size_and_subdivisions()

@export var subdivisions_per_meter_width : int = 0:
	set(value):
		subdivisions_per_meter_width = value
		_recalculate_subdivisions()

@export var subdivisions_per_meter_depth : int = 0:
	set(value):
		subdivisions_per_meter_depth = value
		_recalculate_subdivisions()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _ready():
	if is_nan(FLOOR_ANGLE):
		if Engine.is_editor_hint():
			FLOOR_ANGLE = EditorGlobalParams.get_global_shader_param("FLOOR_ANGLE")
		else:
			FLOOR_ANGLE = GlobalParams.get_global_shader_param("FLOOR_ANGLE")
	
	if not mesh:
		mesh = PlaneMesh.new()
		mesh.orientation = PlaneMesh.FACE_Y
		_recalculate_size_and_subdivisions()
	
	if not mesh.material:
		_apply_material()
		_apply_texture()


func _recalculate_size_and_subdivisions():
	if not mesh:
		return
	
	if not texture:
		mesh.size = Vector2(1, 1)
	else:
		mesh.size = texture.get_size() * pixel_size
		mesh.size.y /= sin(FLOOR_ANGLE)
	
	_recalculate_subdivisions()


func _recalculate_subdivisions():
	if not mesh:
		return
	
	mesh.subdivide_width = roundi(mesh.size.x * subdivisions_per_meter_width)
	mesh.subdivide_depth = roundi(mesh.size.y * subdivisions_per_meter_depth)


func _apply_material():
	var shader_material := ShaderMaterial.new()
	shader_material.shader = load("res://shaders/horizontal.gdshader")
	mesh.material = shader_material


func _apply_texture():
	if not mesh:
		return
	
	if not mesh.material:
		return
	
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprite_texture", texture)

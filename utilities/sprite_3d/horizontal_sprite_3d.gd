@tool
@icon("Sprite3D.svg")
class_name HorizontalSprite3D
extends MeshInstance3D
## Base class for horizontal 3D sprites.
## 
## Horizontal sprites should be meshes instead of just Sprite3Ds so that you can
## create the required number of vertices to have like a smooth curve. Also, due
## to how Godot deals with transparent meshes, try not to make horizontal sprites
## transparent.

# Set the properties in the appropriate json file.
static var FLOOR_GRADIENT : float = NAN

## Toggle to regenerate the sprite.
@export var generate_sprite : bool = false:
	set(value):
		generate_sprite = false
		if value:
			_recalculate_size_and_subdivisions()
			_apply_texture()

@export_category("Sprite Properties")
## Texture for the sprite.
@export var texture : Texture2D:
	set(value):
		texture = value
		_recalculate_size_and_subdivisions()
		_apply_texture()

## Pixel size for the texture. Does not have to follow the global pixel size.
@export_range(0.001, 128, 0.001, "suffix:m") var pixel_size : float = 0.01:
	set(value):
		pixel_size = value
		_recalculate_size_and_subdivisions()

## Number of subdivisions in the x direction per Godot meter unit.
@export var subdivisions_per_meter_width : int = 0:
	set(value):
		subdivisions_per_meter_width = value
		_recalculate_subdivisions()

## Number of subdivisions in the z direction per Godot meter unit.
@export var subdivisions_per_meter_depth : int = 0:
	set(value):
		subdivisions_per_meter_depth = value
		_recalculate_subdivisions()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _ready():
	if not mesh:
		mesh = PlaneMesh.new()
		mesh.orientation = PlaneMesh.FACE_Y
		_recalculate_size_and_subdivisions()
	
	if not mesh.material:
		_apply_material()
		_apply_texture()


# Recalculate the needed size and subdivisions based on the texture pixel size
# and above settings.
func _recalculate_size_and_subdivisions():
	if not mesh:
		return
	
	if is_nan(FLOOR_GRADIENT):
		FLOOR_GRADIENT = GlobalParams.get_global_shader_param("FLOOR_GRADIENT")
	
	if not texture:
		mesh.size = Vector2(1, 1)
	else:
		mesh.size = texture.get_size() * pixel_size
		mesh.size.y /= FLOOR_GRADIENT
	
	_recalculate_subdivisions()


func _recalculate_subdivisions():
	if not mesh:
		return
	
	mesh.subdivide_width = roundi(mesh.size.x * subdivisions_per_meter_width)
	mesh.subdivide_depth = roundi(mesh.size.y * subdivisions_per_meter_depth)


func _apply_material():
	var shader_material := ShaderMaterial.new()
	shader_material.shader = load("res://shaders/opaque_mesh.gdshader")
	mesh.material = shader_material


func _apply_texture():
	if not mesh:
		return
	
	if not mesh.material:
		return
	
	var shader_material : ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprite_texture", texture)

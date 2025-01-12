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

## Max half screen height for custom aabb.
const MAX_SCREEN_HEIGHT: float = 2.4

# Set the properties in the appropriate json file.
static var FLOOR_GRADIENT: float = NAN

## The shader used for HorizontalSprite3D.
static var OPAQUE_MESH: Shader = preload("uid://d1k1is2iascea")

## Button to regenerate the sprite.
@export_tool_button("Regenerate Mesh", "Sprite3D")
var generate_mesh: Callable = _regenerate_mesh

@export_category("Sprite Properties")
## Texture for the sprite.
@export var texture: Texture2D:
	set(value):
		texture = value
		_recalculate_size_and_subdivisions()
		_apply_texture()

## Pixel size for the texture. Does not have to follow the global pixel size.
@export_range(0.001, 128, 0.001, "suffix:m") var pixel_size: float = 0.01:
	set(value):
		pixel_size = value
		_recalculate_size_and_subdivisions()

## Number of subdivisions in the x direction per Godot meter unit.
@export var subdivisions_per_meter_width: int = 0:
	set(value):
		if value < 0:
			return
		subdivisions_per_meter_width = value
		_recalculate_subdivisions()

## Number of subdivisions in the z direction per Godot meter unit.
## [br]Set to -1 to automatically match pixels with subdivisions.
@export var subdivisions_per_meter_depth: int = -1:
	set(value):
		if value < -1:
			return
		subdivisions_per_meter_depth = value
		_recalculate_subdivisions()


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _ready():
	if not mesh:
		_recalculate_size_and_subdivisions()
	
	if not mesh.material:
		_apply_material()
		_apply_texture()
	
	global_position = GlobalParams.get_snapped_position(global_position)


func _regenerate_mesh():
	_recalculate_size_and_subdivisions()
	_apply_material()
	_apply_texture()


# Recalculate the needed size and subdivisions based on the texture pixel size
# and above settings.
func _recalculate_size_and_subdivisions():
	if not mesh:
		mesh = PlaneMesh.new()
		mesh.orientation = PlaneMesh.FACE_Y
	
	_recalculate_size()
	_recalculate_custom_aabb()
	_recalculate_subdivisions()


func _recalculate_size():
	if is_nan(FLOOR_GRADIENT):
		FLOOR_GRADIENT = GlobalParams.get_global_param("FLOOR_GRADIENT")
	
	if not texture:
		mesh.size = Vector2(1, 1)
	else:
		mesh.size = texture.get_size() * pixel_size
		mesh.size.y /= FLOOR_GRADIENT


func _recalculate_custom_aabb():
	var half_mesh_size: Vector2 = mesh.size / 2.0
	var aabb_position: Vector3 = mesh.center_offset \
			- Vector3(half_mesh_size.x, MAX_SCREEN_HEIGHT, half_mesh_size.y)
	var aabb_size: Vector3 = Vector3(mesh.size.x, 0.0, mesh.size.y)
	var y_height: float = GlobalParams.get_global_param("ARC_HEIGHT") \
			+ MAX_SCREEN_HEIGHT
	aabb_size.y = aabb_size.y + y_height
	mesh.custom_aabb = AABB(aabb_position, aabb_size)


func _recalculate_subdivisions():
	if not mesh:
		return
	
	mesh.subdivide_width = roundi(mesh.size.x * subdivisions_per_meter_width)
	if subdivisions_per_meter_depth == -1:
		mesh.subdivide_depth = (texture.get_height() - 1) if texture \
				else roundi(mesh.size.y * FLOOR_GRADIENT / pixel_size)
	else:
		mesh.subdivide_depth = roundi(mesh.size.y * subdivisions_per_meter_depth)


func _apply_material():
	var shader_material := ShaderMaterial.new()
	shader_material.shader = OPAQUE_MESH
	mesh.material = shader_material


func _apply_texture():
	if not mesh:
		return
	
	if not mesh.material:
		return
	
	var shader_material: ShaderMaterial = mesh.material
	shader_material.set_shader_parameter("sprite_texture", texture)

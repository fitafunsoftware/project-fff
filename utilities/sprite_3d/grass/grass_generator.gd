@tool
class_name GrassGenerator
extends Node3D
## Node to generate grass.
##
## Takes a grass texture and creates a bunch of grass meshes based on a given
## grass map. Toggle the generate grass boolean to regenerate the grass.

## Max half screen height for custom aabb.
const MAX_SCREEN_HEIGHT: float = 2.4

## The shader used for grass meshes.
const GRASS_SHADER: Shader = preload("uid://b24wm6l72qnrk")

# Global parameters. Set in the appropriate jsons.
static var PIXEL_SIZE: float = NAN
static var FLOOR_GRADIENT: float = NAN

## Button to regenerate the grass.
@export_tool_button("Regenerate Grass", "Sprite3D")
var regenerate_grass: Callable = _regenerate_grass

@export_category("Grass Properties")
## Individual grass texture to be used. Is repeated.
@export var grass_texture: Texture2D
## Grass map to determine how much grass to be placed and where.
@export var grass_map: Texture2D
## Y Offset of grass to make grass closer together or further apart instead of
## being exactly grass texture height apart.
@export_range(-32, 32, 1, "suffix:pixels") var y_offset: int = 0

var _mesh: Mesh
var _columns: int
var _rows: int
var _row_length: float
var _row_height: float
var _distance_between_rows: float


func _ready():
	_assign_globals()
	_assign_variables()
	
	var occluder := Occluder.new()
	occluder.set_height(_row_height)
	
	for child: Node in get_children():
		if child is GrassInstance3D:
			child.occluder = occluder


# Function to generate the grass.
func _regenerate_grass():
	_clear_grass()
	_create_mesh()
	_create_grass_instances()


# Function to clear all the grass previously generated.
func _clear_grass():
	for child: Node in get_children():
		if not child.is_queued_for_deletion():
			child.free()
	
	_mesh = null


# Assign the global parameters actual values.
func _assign_globals():
	if NAN in [PIXEL_SIZE, FLOOR_GRADIENT]:
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_GRADIENT = GlobalParams.get_global_param("FLOOR_GRADIENT")


# Assign values to helper variables.
func _assign_variables():
	if not grass_texture or not grass_map:
		return
	
	_columns = grass_map.get_width()
	_rows = grass_map.get_height()
	
	_row_length = grass_texture.get_width() * _columns * PIXEL_SIZE
	_row_height = grass_texture.get_height() * PIXEL_SIZE
	_distance_between_rows = (_row_height - y_offset * PIXEL_SIZE) / FLOOR_GRADIENT
	
	position.y = _row_height / 2.0


# Create the basic grass mesh used by every grass node generated.
func _create_mesh():
	if not grass_texture or not grass_map:
		return
	
	var shader_material := ShaderMaterial.new()
	shader_material.shader = GRASS_SHADER
	shader_material.set_shader_parameter("sprite_texture", grass_texture)
	shader_material.set_shader_parameter("grid", Vector2(_rows, _columns))
	shader_material.set_shader_parameter("bitmap_texture", grass_map)
	
	var quad_mesh := QuadMesh.new()
	quad_mesh.orientation = PlaneMesh.FACE_Z
	quad_mesh.size = Vector2(_row_length, _row_height)
	quad_mesh.center_offset = Vector3(_row_length/2.0, 0.0, 0.0)
	quad_mesh.material = shader_material
	quad_mesh.custom_aabb = _get_custom_aabb(quad_mesh)
	
	_mesh = quad_mesh


func _get_custom_aabb(mesh: PrimitiveMesh) -> AABB:
	var aabb: AABB = mesh.get_aabb()
	var y_height: float = GlobalParams.get_global_param("ARC_HEIGHT") \
			+ MAX_SCREEN_HEIGHT
	aabb.position.y -= MAX_SCREEN_HEIGHT
	aabb.size.y += y_height
	return aabb


# Create a bunch of grass instances.
func _create_grass_instances():
	if not grass_texture or not grass_map:
		return
	
	global_position = GlobalParams.get_snapped_position(global_position)
	var grass_position := Vector3.ZERO
	
	var row_info := Vector2(_distance_between_rows*_rows, to_global(grass_position).z)
	_mesh.material.set_shader_parameter("row_info", row_info)
	
	for row: int in _rows:
		var grass_instance := GrassInstance3D.new()
		grass_instance.name = "GrassInstance"
		grass_instance.mesh = _mesh
		grass_instance.position = grass_position
		
		add_child(grass_instance, Engine.is_editor_hint())
		grass_instance.owner = owner
		
		grass_position.z += _distance_between_rows

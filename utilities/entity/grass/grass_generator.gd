@tool
class_name GrassGenerator
extends Node3D
## Node to generate grass.
##
## Takes a grass texture and creates a bunch of grass meshes based on a given
## grass map. Toggle the generate grass boolean to regenerate the grass.

## The shader used for grass meshes.
const GRASS_SHADER : Shader = preload("res://shaders/grass.gdshader")

# Global parameters. Set in the appropriate jsons.
static var PIXEL_SIZE : float = NAN
static var FLOOR_GRADIENT : float = NAN

## Toggle to generate grass. Basically a button that remakes the grass.
@export var generate_grass : bool = false:
	set(value):
		generate_grass = false
		if value:
			_clear_grass()
			_generate_grass()

@export_category("Grass Properties")
## Individual grass texture to be used. Is repeated.
@export var grass_texture : Texture2D
## Grass map to determine how much grass to be placed and where.
@export var grass_map : Texture2D
## Y Offset of grass to make grass closer together or further apart instead of
## being exactly grass texture height apart.
@export_range(-32, 32, 1, "suffix:pixels") var y_offset : int = 0

var _mesh : Mesh
var _columns : int
var _rows : int
var _row_length : float
var _row_height : float
var _distance_between_rows : float


func _ready():
	_assign_globals()
	_assign_variables()
	
	var occluder := Occluder.new()
	occluder.set_height(_row_height)
	
	for grass in get_children():
		grass.occluder = occluder


# Function to generate the grass.
func _generate_grass():
	_assign_globals()
	_assign_variables()
	_create_mesh()
	_create_grass_instances()


# Function to clear all the grass previously generated.
func _clear_grass():
	for child in get_children():
		child.queue_free()
	
	_mesh = null


# Assign the global parameters actual values.
func _assign_globals():
	if [PIXEL_SIZE, FLOOR_GRADIENT].has(NAN):
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_GRADIENT = GlobalParams.get_global_shader_param("FLOOR_GRADIENT")


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
	shader_material.set_shader_parameter("columns", float(_columns))
	shader_material.set_shader_parameter("rows", float(_rows))
	shader_material.set_shader_parameter("bitmap_texture", grass_map)
	
	var quad_mesh := QuadMesh.new()
	quad_mesh.orientation = PlaneMesh.FACE_Z
	quad_mesh.size = Vector2(_row_length, _row_height)
	quad_mesh.material = shader_material
	
	_mesh = quad_mesh


# Create a bunch of grass instances.
func _create_grass_instances():
	if not grass_texture or not grass_map:
		return
	
	var start_z_position : float = -_rows/2.0 * _distance_between_rows
	var start_x_position : float = -_row_length/2.0
	
	var grass_position := Vector3(0.0, 0.0, 0.0)
	grass_position.z = start_z_position
	grass_position.x = snappedf(global_position.x, 0.01) + fmod(start_x_position, PIXEL_SIZE)
	
	var top_most := to_global(grass_position)
	top_most = Vector3(_distance_between_rows * _rows, 0.0, top_most.z)
	_mesh.material.set_shader_parameter("top_most", top_most)
	
	for row in _rows:
		var grass_instance := GrassInstance3D.new()
		grass_instance.name = "GrassInstance"
		grass_instance.mesh = _mesh
		grass_instance.position = grass_position
		
		add_child(grass_instance, Engine.is_editor_hint())
		grass_instance.owner = owner
		
		grass_position.z += _distance_between_rows

@tool
extends Node3D
class_name GrassGenerator

var PIXEL_SIZE : float = 0.01
var FLOOR_ANGLE : float = 0.524
var CAMERA_Z_OFFSET : float = 15.0

@export var generate_grass : bool = false:
	set(value):
		generate_grass = false
		if value:
			_clear_grass()
			_generate_grass()

@export_category("Grass Properties")
@export var grass_texture : Texture2D
@export var grass_map : Texture2D
@export_range(-32, 32, 1, "suffix:pixels") var y_offset : int = 0

var _mesh : Mesh
var _columns : int
var _rows : int
var _row_length : float
var _row_height : float
var _distance_between_rows : float


func _ready():
	_assign_consts()
	_assign_variables()
	
	var occluder := Occluder.new()
	occluder.set_height(_row_height, CAMERA_Z_OFFSET)
	
	for grass in get_children():
		grass.occluder = occluder


func _generate_grass():
	_assign_consts()
	_assign_variables()
	_create_mesh()
	_create_grass_instances()


func _clear_grass():
	for child in get_children():
		child.queue_free()
	
	_mesh = null


func _assign_consts():
	if not Engine.is_editor_hint():
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_ANGLE = GlobalParams.get_global_shader_param("FLOOR_ANGLE")
		CAMERA_Z_OFFSET = GlobalParams.get_global_shader_param("CAMERA_Z_OFFSET")


func _assign_variables():
	if not grass_texture or not grass_map:
		return
	
	_columns = grass_map.get_width()
	_rows = grass_map.get_height()
	
	_row_length = grass_texture.get_width() * _columns * PIXEL_SIZE
	_row_height = grass_texture.get_height() * PIXEL_SIZE
	_distance_between_rows = (_row_height - y_offset * PIXEL_SIZE) / sin(FLOOR_ANGLE)
	
	position.y = _row_height / 2.0


func _create_mesh():
	if not grass_texture or not grass_map:
		return
	
	var shader_material := ShaderMaterial.new()
	shader_material.shader = load("res://shaders/grass.gdshader")
	shader_material.set_shader_parameter("sprite_texture", grass_texture)
	shader_material.set_shader_parameter("columns", _columns)
	shader_material.set_shader_parameter("rows", _rows)
	shader_material.set_shader_parameter("bitmap_texture", grass_map)
	
	var quad_mesh := QuadMesh.new()
	quad_mesh.orientation = PlaneMesh.FACE_Z
	quad_mesh.size = Vector2(_row_length, _row_height)
	quad_mesh.material = shader_material
	
	_mesh = quad_mesh


func _create_grass_instances():
	if not grass_texture or not grass_map:
		return
	
	var start_z_position : float = -_rows/2.0 * _distance_between_rows
	var start_x_position : float = -_row_length/2.0
	
	var grass_position := Vector3(0.0, 0.0, 0.0)
	grass_position.z = start_z_position
	global_position.x = snappedf(global_position.x, 0.01) + fmod(start_x_position, PIXEL_SIZE)
	
	var top_most := to_global(grass_position)
	top_most = Vector3(_distance_between_rows * _rows, 0.0, top_most.z)
	_mesh.material.set_shader_parameter("top_most", top_most)
	
	for row in _rows:
		var grass_instance := GrassInstance3D.new()
		grass_instance.mesh = _mesh
		grass_instance.position = grass_position
		
		add_child(grass_instance)
		grass_instance.owner = owner
		
		grass_position.z += _distance_between_rows

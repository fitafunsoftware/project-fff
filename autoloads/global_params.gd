extends Node

var global_params : Dictionary
var global_shader_params : Dictionary


func _ready():
	_initialize_params()
	
	for param in global_shader_params.keys():
		RenderingServer.global_shader_parameter_set(param, global_shader_params[param])
	
	_calculate_circle_consts()


func get_global_param(param):
	return global_params[param]


func get_global_shader_param(param):
	return global_shader_params[param]


func _initialize_params():
	global_params = JSON.parse_string(FileAccess.get_file_as_string("res://global_params/global_params.json"))
	global_shader_params = JSON.parse_string(FileAccess.get_file_as_string("res://global_params/global_shader_params.json"))


func _calculate_circle_consts():
	var radius : float = global_shader_params["CURVE_HEIGHT"]/global_shader_params["CURVE_HEIGHT_RATIO"]
	var arc_height : float = radius - global_shader_params["CURVE_HEIGHT"]
	var arc_length : float = sqrt(pow(radius, 2) - pow(arc_height, 2))
	var floor_gradient :float = arc_length/arc_height
	
	global_shader_params["RADIUS"] = radius
	global_shader_params["ARC_HEIGHT"] = arc_height
	global_shader_params["ARC_LENGTH"] = arc_length
	global_shader_params["FLOOR_GRADIENT"] = floor_gradient

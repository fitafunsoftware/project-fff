extends Node

var global_shader_params : Dictionary


func _ready():
	_initialize_params()
	
	for param in global_shader_params.keys():
		RenderingServer.global_shader_parameter_set(param, global_shader_params[param])


func get_global_shader_param(param):
	return global_shader_params[param]


func _initialize_params():
	global_shader_params = JSON.parse_string(FileAccess.get_file_as_string("res://global_params/global_shader_params.json"))

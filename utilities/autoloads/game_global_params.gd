extends Node
## Autoload for global game parameters.
##
## Stores all the global paramaters for centralization. Shader parameters are
## loaded to the [RenderingServer] after initialization. Other constants
## are also calculated and stored here. Access this autoload through the static
## [GlobalParams] class.

## File path for the global params JSON.[br]
const GLOBAL_PARAMS_JSON : String = "res://global_params/global_params.json"
## File path for the global shader params JSON.
const GLOBAL_SHADER_PARAMS_JSON : String = "res://global_params/global_shader_params.json"

# Dictionary to store global paramaters.
var _global_params : Dictionary
# Dictionary to store global shader parameters.
var _global_shader_params : Dictionary

# Initialize the parameters. Assign the global shader parameters to 
# the [RenderingServer]. Calculate other global parameters.
func _ready():
	_initialize_params()
	
	for param in _global_shader_params.keys():
		RenderingServer.global_shader_parameter_set(param, _global_shader_params[param])
	
	_calculate_circle_consts()


## Get the global parameter with the key [param param].
func get_global_param(param) -> Variant:
	return _global_params[param]


## Get the global shader parameter with the key [param param].
func get_global_shader_param(param):
	return _global_shader_params[param]


# Initialize global parameters and global shader parameters from JSON files.
func _initialize_params():
	_global_params = JSON.parse_string(FileAccess.get_file_as_string(GLOBAL_PARAMS_JSON))
	_global_shader_params = JSON.parse_string(FileAccess.get_file_as_string(GLOBAL_SHADER_PARAMS_JSON))


# Calculate the circle constants from the shader parameters.
func _calculate_circle_consts():
	var radius : float = _global_shader_params["CURVE_HEIGHT"]/_global_shader_params["CURVE_HEIGHT_RATIO"]
	var arc_height : float = radius - _global_shader_params["CURVE_HEIGHT"]
	var arc_length : float = sqrt(pow(radius, 2) - pow(arc_height, 2))
	var floor_gradient :float = arc_length/arc_height
	
	_global_shader_params["RADIUS"] = radius
	_global_shader_params["ARC_HEIGHT"] = arc_height
	_global_shader_params["ARC_LENGTH"] = arc_length
	_global_shader_params["FLOOR_GRADIENT"] = floor_gradient

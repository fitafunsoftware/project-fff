extends Node
## Autoload for global game parameters.
##
## Stores all the global paramaters for centralization. Shader parameters are
## loaded to the [RenderingServer] after initialization. Other constants
## are also calculated and stored here. Access this autoload through the static
## [GlobalParams] class.

## File path for the global params JSON.[br]
const GLOBAL_PARAMS_JSON : String = "res://global_params/global_params.json"

# Dictionary to store global paramaters.
var _global_params : Dictionary

# Initialize the parameters. Calculate other global parameters. Assign the 
# global shader parameters to the [RenderingServer].
func _ready():
	_initialize_params()


## Get the global parameter with the key [param param].
func get_global_param(param) -> Variant:
	if _global_params.is_empty():
		_initialize_params()
	return _global_params[param]


## Get the position snapped to pixel positions.
func get_snapped_position(global_position: Vector3) -> Vector3:
	if _global_params.is_empty():
		_initialize_params()
	var pixel_size : float = _global_params["PIXEL_SIZE"]
	var floor_gradient : float = _global_params["FLOOR_GRADIENT"]
	
	global_position.x = snappedf(global_position.x, pixel_size)
	global_position.y = snappedf(global_position.y, pixel_size)
	global_position.z = snappedf(global_position.z, pixel_size/floor_gradient)
	
	return global_position


# Initialize global parameters and global shader parameters from JSON files.
func _initialize_params():
	_global_params = JSON.parse_string(FileAccess.get_file_as_string(GLOBAL_PARAMS_JSON))
	GlobalParams.append_curve_params(_global_params)
	
	for param in _global_params.keys():
		if ProjectSettings.has_setting("shader_globals/" + param):
			RenderingServer.global_shader_parameter_set(param, _global_params[param])


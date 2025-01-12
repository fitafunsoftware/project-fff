extends Node
## Autoload for global game parameters.
##
## Stores all the global paramaters for centralization. Shader parameters are
## loaded to the [RenderingServer] after initialization. Other constants
## are also calculated and stored here. Access this autoload through the static
## [GlobalParams] class.

## File path for the global params JSON.[br]
const GLOBAL_PARAMS_JSON: String = "uid://dm1x50lqxmifh"

# Dictionary to store global paramaters.
var _global_params: Dictionary[StringName, Variant]
var _frame_time: int

# Initialize the parameters. Calculate other global parameters. Assign the 
# global shader parameters to the [RenderingServer].
func _ready():
	_initialize_params()
	sync_frame_time(0, Time.get_ticks_msec())


func _physics_process(_delta: float):
	_frame_time += 1


## Get the current frame time. Units is in physics frames.
func get_frame_time() -> int:
	return _frame_time


## Function to sync up frame times between systems.[br]The given [param ticks_msec]
## will be compared with this system's ticks msec and compensation frames will be
## added onto the given [param starting_frame] to account for time passed 
## between the method call.[br]The [param compensation] paramater can be added
## to offset any inherent differences in ticks msec between the two systems.
func sync_frame_time(starting_frame: int, ticks_msec: int, 
		compensation: int = 0):
	var current_time: int = Time.get_ticks_msec()
	var delta_time: int = current_time - (ticks_msec + compensation)
	@warning_ignore("integer_division")
	var compensation_frames: int = \
			(delta_time * Engine.physics_ticks_per_second) / 1000
	
	_frame_time = starting_frame + compensation_frames


## Get the global parameter with the key [param param].
func get_global_param(param: StringName) -> Variant:
	if _global_params.is_empty():
		_initialize_params()
	return _global_params[param]


## Get the position snapped to pixel positions.
func get_snapped_position(global_position: Vector3) -> Vector3:
	if _global_params.is_empty():
		_initialize_params()
	var pixel_size: float = _global_params["PIXEL_SIZE"]
	var floor_gradient: float = _global_params["FLOOR_GRADIENT"]
	
	global_position.x = snappedf(global_position.x, pixel_size)
	global_position.y = snappedf(global_position.y, pixel_size)
	global_position.z = snappedf(global_position.z, pixel_size/floor_gradient)
	
	return global_position


# Initialize global parameters and global shader parameters from JSON files.
func _initialize_params():
	_global_params.assign(JSON.parse_string(FileAccess.get_file_as_string(GLOBAL_PARAMS_JSON)))
	GlobalParams.append_curve_params(_global_params)
	
	for param: StringName in _global_params.keys():
		if ProjectSettings.has_setting("shader_globals/" + param):
			RenderingServer.global_shader_parameter_set(param, _global_params[param])

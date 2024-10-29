class_name GlobalParams
## Static class to access global parameters.
##
## This static class helps use either the [GameGlobalParams] autoload, when the
## game is running, or the [EditorGlobalParams], when viewing things in the Editor.
## Note, you won't see shader parameters changed in scene, but tool functions
## that require these parameters have access to them if needed.


## Returns the current frame time. Units is in physics frames.
static func get_frame_time() -> int:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_frame_time()
	else:
		return GameGlobalParams.get_frame_time()


## Function to sync up frame times between systems.[br]More information in
## [GameGlobalParams] on arguments.[br]Does nothing when called in editor.
static func sync_frame_time(starting_frame: int, ticks_msec: int, 
		time_compensation: int = 0):
	if Engine.is_editor_hint():
		return
	GameGlobalParams.sync_frame_time(starting_frame, ticks_msec, time_compensation)


## Returns the global parameter with the name param.
static func get_global_param(param: String) -> Variant:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_global_param(param)
	else:
		return GameGlobalParams.get_global_param(param)


## Get the position snapped to pixel positions.
static func get_snapped_position(global_position: Vector3) -> Vector3:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_snapped_position(global_position)
	else:
		return GameGlobalParams.get_snapped_position(global_position)


## Calculate [b]and add[/b] the curve constants to the passed in dictionary.
## Note that this function [b]directly manipulates[/b] the Dictionary.
static func append_curve_params(global_params: Dictionary):
	var arc_height: float = global_params["ARC_HEIGHT"]
	var floor_angle: float = deg_to_rad(global_params["FLOOR_ANGLE_DEGREES"])
	var radius : float = arc_height/(1.0 - cos(floor_angle))
	var distance_to_chord : float = radius - arc_height
	var half_chord_length : float = radius * sin(floor_angle)
	var floor_gradient :float = tan(floor_angle)
	
	global_params["RADIUS"] = radius
	global_params["DISTANCE_TO_CHORD"] = distance_to_chord
	global_params["HALF_CHORD_LENGTH"] = half_chord_length
	global_params["FLOOR_GRADIENT"] = floor_gradient


class EditorGlobalParams:
## Inner class to handle global parameters in the Editor.
##
## In the Editor, the GameGlobalParams autoload does not exist. As such, this
## static class is called instead. Being a static class, it has no memory and
## things need to be loaded as needed every time the function is called. Interact
## with this class through [GlobalParams] instead of directly with this class.


## Get the current frame time. In editor, this class specifically, this returns -1.
	static func get_frame_time() -> int:
		return -1


## Get the global parameter with the name param.
	static func get_global_param(param: String) -> Variant:
		var global_params: Dictionary = JSON.parse_string(
				FileAccess.get_file_as_string("res://global_params/global_params.json"))
		GlobalParams.append_curve_params(global_params)
		
		return global_params[param]


## Get the position snapped to pixel positions.
	static func get_snapped_position(global_position: Vector3) -> Vector3:
		var global_params: Dictionary = JSON.parse_string(
				FileAccess.get_file_as_string("res://global_params/global_params.json"))
		var pixel_size: float = global_params["PIXEL_SIZE"]
		var floor_gradient: float = tan(deg_to_rad(global_params["FLOOR_ANGLE_DEGREES"]))
		
		global_position.x = snappedf(global_position.x, pixel_size)
		global_position.y = snappedf(global_position.y, pixel_size)
		global_position.z = snappedf(global_position.z, pixel_size/floor_gradient)
		
		return global_position

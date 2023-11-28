class_name GlobalParams
## Static class to access global parameters.
##
## This static class helps use either the [GameGlobalParams] autoload, when the
## game is running, or the [EditorGlobalParams], when viewing things in the Editor.
## Note, you won't see shader parameters changed in scene, but tool functions
## that require these parameters have access to them if needed.


## Returns the global parameter with the name param.
static func get_global_param(param: String) -> Variant:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_global_param(param)
	else:
		return GameGlobalParams.get_global_param(param)


## Returns the global shader parameter with the name param.
static func get_global_shader_param(param: String) -> Variant:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_global_shader_param(param)
	else:
		return GameGlobalParams.get_global_shader_param(param)


## Calculate [b]and add[/b] the curve constants to the passed in dictionary.
## Note that this function [b]directly manipulates[/b] the Dictionary.
static func append_circle_params(global_shader_params: Dictionary):
	var arc_height = global_shader_params["ARC_HEIGHT"]
	var floor_angle = deg_to_rad(global_shader_params["FLOOR_ANGLE_DEGREES"])
	var radius : float = arc_height/(1.0 - cos(floor_angle))
	var distance_to_chord : float = radius - arc_height
	var half_chord_length : float = radius * sin(floor_angle)
	var floor_gradient :float = tan(floor_angle)
	
	global_shader_params["RADIUS"] = radius
	global_shader_params["DISTANCE_TO_CHORD"] = distance_to_chord
	global_shader_params["HALF_CHORD_LENGTH"] = half_chord_length
	global_shader_params["FLOOR_GRADIENT"] = floor_gradient


class EditorGlobalParams:
## Inner class to handle global parameters in the Editor.
##
## In the Editor, the GameGlobalParams autoload does not exist. As such, this
## static class is called instead. Being a static class, it has no memory and
## things need to be loaded as needed every time the function is called. Interact
## with this class through [GlobalParams] instead of directly with this class.


## Get the global parameter with the name param.
	static func get_global_param(param: String) -> Variant:
		var global_params = JSON.parse_string(
				FileAccess.get_file_as_string("res://global_params/global_params.json"))
		return global_params[param]


## Get the global shader parameter with the name param.
	static func get_global_shader_param(param: String) -> Variant:
		var global_shader_params = JSON.parse_string(
				FileAccess.get_file_as_string("res://global_params/global_shader_params.json"))
		GlobalParams.append_circle_params(global_shader_params)
		
		return global_shader_params[param]

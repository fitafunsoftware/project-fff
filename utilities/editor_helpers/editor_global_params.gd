class_name EditorGlobalParams
## Static class to handle global parameters in the Editor.
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
	_calculate_circle_consts(global_shader_params)
	
	return global_shader_params[param]


# Helper function to generate the circle constants that need to be calculated.
static func _calculate_circle_consts(global_shader_params: Dictionary):
	var radius : float = global_shader_params["CURVE_HEIGHT"]/global_shader_params["CURVE_HEIGHT_RATIO"]
	var arc_height : float = radius - global_shader_params["CURVE_HEIGHT"]
	var arc_length : float = sqrt(pow(radius, 2) - pow(arc_height, 2))
	var floor_gradient :float = arc_length/arc_height
	
	global_shader_params["RADIUS"] = radius
	global_shader_params["ARC_HEIGHT"] = arc_height
	global_shader_params["ARC_LENGTH"] = arc_length
	global_shader_params["FLOOR_GRADIENT"] = floor_gradient

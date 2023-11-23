class_name GlobalParams
## Static class to access global parameters.
##
## This static class helps use either the [GameGlobalParams] autoload, when the
## game is running, or the [EditorGlobalParams], when viewing things in the Editor.


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


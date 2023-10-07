class_name GlobalParams


static func get_global_param(param: String) -> Variant:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_global_param(param)
	else:
		return GameGlobalParams.get_global_param(param)


static func get_global_shader_param(param: String) -> Variant:
	if Engine.is_editor_hint():
		return EditorGlobalParams.get_global_shader_param(param)
	else:
		return GameGlobalParams.get_global_shader_param(param)


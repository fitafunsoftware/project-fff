class_name EditorGlobalParams


static func get_global_param(param: String) -> Variant:
	var global_params = JSON.parse_string(FileAccess.get_file_as_string("res://global_params/global_params.json"))
	return global_params[param]


static func get_global_shader_param(param: String) -> Variant:
	var global_shader_params = JSON.parse_string(FileAccess.get_file_as_string("res://global_params/global_shader_params.json"))
	return global_shader_params[param]



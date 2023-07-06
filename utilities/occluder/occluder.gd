extends Resource
class_name Occluder

static var CAMERA_Z_OFFSET : float = NAN
var z_cutoff_distance : float = 0.0


func to_occlude(global_pos_z : float, camera_global_pos_z : float) -> bool:
	if camera_global_pos_z - global_pos_z >= z_cutoff_distance:
		return true
	elif camera_global_pos_z - global_pos_z <= 0.0:
		return true
	else:
		return false


func set_height(height : float):
	if is_nan(CAMERA_Z_OFFSET):
		CAMERA_Z_OFFSET = EditorGlobalParams.get_global_shader_param("CAMERA_Z_OFFSET") \
				if Engine.is_editor_hint() else GlobalParams.get_global_shader_param("CAMERA_Z_OFFSET")
	
	z_cutoff_distance = CAMERA_Z_OFFSET + ShaderDisplacement.get_corresponding_z_distance(height)

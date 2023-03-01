extends Resource
class_name Occluder

var z_cutoff_distance : float = 0.0


func to_occlude(global_pos_z : float, camera_global_pos_z : float) -> bool:
	if camera_global_pos_z - global_pos_z >= z_cutoff_distance:
		return true
	elif camera_global_pos_z - global_pos_z <= 0.0:
		return true
	else:
		return false


func set_height(height : float, CAMERA_Z_OFFSET : float = 15.0):
	z_cutoff_distance = CAMERA_Z_OFFSET + ShaderDisplacement.get_corresponding_z_distance(height)

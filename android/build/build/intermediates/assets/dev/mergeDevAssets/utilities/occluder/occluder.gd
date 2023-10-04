class_name Occluder
extends Resource

static var CAMERA_Z_OFFSET : float = NAN
static var CURVE_HEIGHT : float = NAN
static var RADIUS : float = NAN
static var ARC_LENGTH : float = NAN

var z_cutoff_distance : float = 0.0


func to_occlude(global_pos_z : float, camera_global_pos_z : float) -> bool:
	if camera_global_pos_z - global_pos_z >= z_cutoff_distance:
		return true
	elif camera_global_pos_z - global_pos_z <= 0.0:
		return true
	else:
		return false


func set_height(height : float):
	if [CAMERA_Z_OFFSET, CURVE_HEIGHT, RADIUS, ARC_LENGTH].has(NAN):
		if Engine.is_editor_hint():
			CAMERA_Z_OFFSET = EditorGlobalParams.get_global_shader_param("CAMERA_Z_OFFSET")
			CURVE_HEIGHT = EditorGlobalParams.get_global_shader_param("CURVE_HEIGHT")
			RADIUS = EditorGlobalParams.get_global_shader_param("RADIUS")
			ARC_LENGTH = EditorGlobalParams.get_global_shader_param("ARC_LENGTH")
		else:
			CAMERA_Z_OFFSET = GlobalParams.get_global_shader_param("CAMERA_Z_OFFSET")
			CURVE_HEIGHT = GlobalParams.get_global_shader_param("CURVE_HEIGHT")
			RADIUS = GlobalParams.get_global_shader_param("RADIUS")
			ARC_LENGTH = GlobalParams.get_global_shader_param("ARC_LENGTH")
	
	z_cutoff_distance = CAMERA_Z_OFFSET + _get_corresponding_z_distance(height)


func _get_corresponding_z_distance(height: float) -> float:
	var length : float = 0.0
	
	if height < CURVE_HEIGHT:
		var adjacent : float = RADIUS - height
		length = sqrt(pow(RADIUS, 2) - pow(adjacent, 2))
	else:
		var excess : float = height - CURVE_HEIGHT
		length = ARC_LENGTH + excess*(RADIUS - CURVE_HEIGHT)/ARC_LENGTH
	
	return length


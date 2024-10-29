class_name Occluder
extends Resource
## Resource to decide whether to occlude.
##
## Resource just to help keep the calculations all in one place.

# Global parameters. Set in the appropriate json file.
static var CAMERA_Z_OFFSET: float = NAN
static var ARC_HEIGHT: float = NAN
static var RADIUS: float = NAN
static var HALF_CHORD_LENGTH: float = NAN

## The cutoff distance for the occluder.
var z_cutoff_distance: float = 0.0


## Return whether to occlude the node or not.
func to_occlude(global_pos_z: float, camera_global_pos_z: float) -> bool:
	if camera_global_pos_z - global_pos_z >= z_cutoff_distance:
		return true
	elif camera_global_pos_z - global_pos_z <= 0.0:
		return true
	else:
		return false


## Set the height of the node and calculate the cutoff distance.
func set_height(height: float):
	if NAN in [CAMERA_Z_OFFSET, ARC_HEIGHT, RADIUS, HALF_CHORD_LENGTH]:
		CAMERA_Z_OFFSET = GlobalParams.get_global_param("CAMERA_Z_OFFSET")
		ARC_HEIGHT = GlobalParams.get_global_param("ARC_HEIGHT")
		RADIUS = GlobalParams.get_global_param("RADIUS")
		HALF_CHORD_LENGTH = GlobalParams.get_global_param("HALF_CHORD_LENGTH")
	
	z_cutoff_distance = CAMERA_Z_OFFSET + _get_corresponding_z_distance(height)


# Calculate the cutoff distance.
func _get_corresponding_z_distance(height: float) -> float:
	var length: float = 0.0
	
	if height < ARC_HEIGHT:
		var adjacent: float = RADIUS - height
		length = sqrt(pow(RADIUS, 2) - pow(adjacent, 2))
	else:
		var excess: float = height - ARC_HEIGHT
		length = HALF_CHORD_LENGTH + excess*(RADIUS - ARC_HEIGHT)/HALF_CHORD_LENGTH
	
	return length

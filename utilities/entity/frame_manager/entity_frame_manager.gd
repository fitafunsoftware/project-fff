@icon("entity_frame_manager.png")
class_name EntityFrameManager
extends FrameManager
## Node to manage frames for Entity synchronization between client and server.

## Acceptable error for each position value.
const ACCEPTABLE_POSITION_ERROR: float = 0.01
## Acceptable error for each velocity value.
const ACCEPTABLE_VELOCITY_ERROR: float = 0.5

## Frame array size.
const FRAME_SIZE: int = 3
# Index of each value in a frame array. FRAME is in the 0th index.
enum {POSITION = 1, VELOCITY}

## Entity to manage frames for.
@export var entity: Entity


## Creates an entity frame using previous position and current velocity values.
func get_current_frame() -> Array:
	var entity_frame: Array = Array()
	entity_frame.resize(FRAME_SIZE)
	entity_frame[FRAME] = GlobalParams.get_frame_time()
	entity_frame[POSITION] = GlobalParams.get_snapped_position(
			entity.global_position - entity.get_position_delta())
	entity_frame[VELOCITY] = entity.get_real_velocity()
	return entity_frame


## Compare two frames to see if their positions and velocities are within
## acceptable differences.
func frames_are_equal(frame: Array, to_compare: Array) -> bool:
	if not _is_within_acceptable_range(frame[POSITION], 
			to_compare[POSITION], ACCEPTABLE_POSITION_ERROR):
		return false
	
	if not _is_within_acceptable_range(frame[VELOCITY],
			to_compare[VELOCITY], ACCEPTABLE_VELOCITY_ERROR):
		return false
	
	return true


## Fix all frames after the newly added [param frame] at the given [param index].
## Updates positions using basic interpolation and the stored frame velocity.
func fix_frames(frame: Array, index: int):
	frames[index] = frame
	var next_position: Vector3 = frame[POSITION] + \
			frame[VELOCITY] * get_physics_process_delta_time()
	index += 1
	while index < frames.size():
		var current_frame: Array = frames[index] as Array
		current_frame[POSITION] = GlobalParams.get_snapped_position(next_position)
		next_position = current_frame[POSITION] + current_frame[VELOCITY] \
				* get_physics_process_delta_time()
		index += 1


## Fix the position of the entity by directly changing its global position if
## required.
func reconcile_differences():
	var latest_frame: Array = frames.back() as Array
	var new_global_position: Vector3 = latest_frame[POSITION] + \
			latest_frame[VELOCITY] * get_physics_process_delta_time()
	new_global_position = GlobalParams.get_snapped_position(new_global_position)
	if not _is_within_acceptable_range(entity.global_position,
			new_global_position, ACCEPTABLE_POSITION_ERROR):
		entity.global_position = new_global_position


# Helper function to compare two vectors and check whether they are within an
# acceptable range of one another.
func _is_within_acceptable_range(vector: Vector3, to_compare: Vector3, 
		error_within: float) -> bool:
	return absf(vector.x - to_compare.x) <= error_within and \
			absf(vector.y - to_compare.y) <= error_within and \
			absf(vector.z - to_compare.z) <= error_within

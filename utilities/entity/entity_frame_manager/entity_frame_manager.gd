extends Node
class_name EntityFrameManager
## Node to manage frames for entity synchronization.

## Acceptable error for each position value.
const ACCEPTABLE_POSITION_ERROR : float = 0.01
## Acceptable error for each velocity value.
const ACCEPTABLE_VELOCITY_ERROR : float = 0.5

# Frame array size.
const FRAME_SIZE : int = 3
# Index of each value in a frame array.
enum {FRAME, POSITION, VELOCITY}

## Entity to manage frames for.
@export var entity : Entity
## Maximum number of frames saved at a time.
@export var physics_frames_saved : int = 60

# Array to hold all the frames within the maximum number of saved frames.
var _frames : Array[Array]


func _ready() -> void:
	_frames.assign([])


func _physics_process(_delta: float) -> void:
	var entity_frame : Array = _get_entity_frame()
	_frames.push_back(entity_frame)
	
	if _frames.size() > physics_frames_saved:
		_frames.pop_front()


## Compare the given [param frame] with the appropriate frame based off of frame time.
## [br]Simulates frames up to the current time if there is enough of a difference
## and update the entity's position appropriately.
## [br]Forgets every frame before [param frame] as this will be the most recent
## frame to be synced to.
func process_frame(frame: Array):
	if _frames.is_empty():
		return
	
	var current_frame : Array = _frames.front() as Array
	var frame_index : int = frame[FRAME] - current_frame[FRAME]
	if frame_index >= _frames.size() or frame_index < 0:
		return
	
	current_frame = _frames[frame_index] as Array
	if not _frames_are_equal(frame, current_frame):
		_fix_frames(frame, frame_index)
		_fix_entity_position()
	
	_frames = _frames.slice(frame_index) as Array[Array]


# Creates an entity frame using current values.
func _get_entity_frame() -> Array:
	var entity_frame : Array = Array()
	entity_frame.resize(FRAME_SIZE)
	entity_frame[FRAME] = GlobalParams.get_frame_time()
	entity_frame[POSITION] = GlobalParams.get_snapped_position(
			entity.global_position - entity.get_position_delta())
	entity_frame[VELOCITY] = entity.get_real_velocity()
	return entity_frame


# Compare two frames to see if they are within acceptable differences.
func _frames_are_equal(frame: Array, to_compare: Array) -> bool:
	if not _is_within_acceptable_range(frame[POSITION], 
			to_compare[POSITION], ACCEPTABLE_POSITION_ERROR):
		return false
	
	if not _is_within_acceptable_range(frame[VELOCITY],
			to_compare[VELOCITY], ACCEPTABLE_VELOCITY_ERROR):
		return false
	
	return true


# Helper function to compare two vectors and check whether they are within an
# acceptable range of one another.
func _is_within_acceptable_range(vector: Vector3, to_compare: Vector3, 
		error_within: float) -> bool:
	return absf(vector.x - to_compare.x) <= error_within and \
			absf(vector.y - to_compare.y) <= error_within and \
			absf(vector.z - to_compare.z) <= error_within


# Fix all frames after the newly added [param frame] at the given [param index].
func _fix_frames(frame: Array, index: int):
	_frames[index] = frame
	var next_position : Vector3 = frame[POSITION] + \
			frame[VELOCITY] * get_physics_process_delta_time()
	index += 1
	while index < _frames.size():
		var current_frame : Array = _frames[index] as Array
		current_frame[POSITION] = GlobalParams.get_snapped_position(next_position)
		next_position = current_frame[POSITION] + current_frame[VELOCITY] \
				* get_physics_process_delta_time()
		index += 1


# Fix the position of the entity by directly changing its global position if
# required.
func _fix_entity_position():
	var latest_frame : Array = _frames.back() as Array
	var new_global_position : Vector3 = latest_frame[POSITION] + \
			latest_frame[VELOCITY] * get_physics_process_delta_time()
	new_global_position = GlobalParams.get_snapped_position(new_global_position)
	if not _is_within_acceptable_range(entity.global_position,
			new_global_position, ACCEPTABLE_POSITION_ERROR):
		entity.global_position = new_global_position

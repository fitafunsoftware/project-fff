extends FrameManager
class_name StateMachineFrameManager
## Node to manage frames for StateMachine synchronization between client and server.

## Frame array size.
const FRAME_SIZE : int = 3
# Index of each value in a frame array. FRAME is in the 0th index.
enum {STATES_STACK = 1, TIME_IN_STATE}

## StateMachine to manage frames for.
@export var state_machine : StateMachine

# Time spent in the current state.
var _time_in_current_state : int = 0


func _ready() -> void:
	super()
	state_machine.state_changed.connect(_reset_time_in_current_state)


func _physics_process(delta: float) -> void:
	_time_in_current_state += 1
	super(delta)


## Creates a StateMachine frame using the current states stack and time in state.
func get_current_frame() -> Array:
	var frame : Array = Array()
	frame.resize(FRAME_SIZE)
	frame[FRAME] = GlobalParams.get_frame_time()
	frame[STATES_STACK] = state_machine.get_states_stack()
	frame[TIME_IN_STATE] = _time_in_current_state
	return frame


## Compare two frames to see if they are within acceptable differences.
func frames_are_equal(frame: Array, to_compare: Array) -> bool:
	if not frame[STATES_STACK].back() == to_compare[STATES_STACK].back():
		return false
	
	if not frame[TIME_IN_STATE] == to_compare[TIME_IN_STATE]:
		return false
	
	return true


## Fix all frames after the newly added [param frame] at the given [param index].
## Any future changes in state are assumed to happen at the same frame still.
func fix_frames(frame: Array, index: int):
	frames[index] = frame
	var previous_state : StringName = frame[STATES_STACK].back() as StringName
	var previous_time_in_state : int = frame[TIME_IN_STATE] as int
	index += 1
	while index < frames.size():
		var current_frame : Array = frames[index] as Array
		var current_state : StringName = current_frame[STATES_STACK].back() as StringName
		if not current_state == previous_state:
			current_frame[TIME_IN_STATE] = 1
		else:
			current_frame[TIME_IN_STATE] = previous_time_in_state + 1
		previous_state = current_state
		previous_time_in_state = current_frame[TIME_IN_STATE]
		index += 1


## Update the states statck and the time in current state to the new latest frame.
func reconcile_differences():
	var latest_frame : Array = frames.back() as Array
	var states_stack : Array[StringName] = latest_frame[STATES_STACK]
	var time_in_state : float = latest_frame[TIME_IN_STATE] * \
			get_physics_process_delta_time()
	state_machine.configure_state_machine(states_stack, time_in_state)


# Signal callbacks.
func _reset_time_in_current_state(_current_state: StringName):
	_time_in_current_state = 0

@icon("frame_manager.png")
class_name FrameManager
extends Node
## Base class for FrameManagers to help synchronize clients and servers.

## The position of frame data in the frame packet.
const FRAME : int = 0

## Maximum number of frames saved at a time.
@export var frames_saved : int = 60

## Array to hold all the frames within the maximum number of saved frames.
var frames : Array[Array]


func _ready() -> void:
	frames.assign([])


func _physics_process(_delta: float) -> void:
	var current_frame : Array = get_current_frame()
	frames.push_back(current_frame)
	
	if frames.size() > frames_saved:
		frames.pop_front()


## Compare the given [param frame] with the appropriate frame based off of frame time.
## [br]Simulates frames up to the current time if there is enough of a difference
## and update the appropriate values.
## [br]Forgets every frame before [param frame] as this will be the most recent
## frame to be synced to.
func process_frame(frame: Array):
	if frames.is_empty():
		return
	
	var current_frame : Array = frames.front() as Array
	var frame_index : int = frame[FRAME] - current_frame[FRAME]
	if frame_index >= frames.size() or frame_index < 0:
		return
	
	current_frame = frames[frame_index] as Array
	if not frames_are_equal(frame, current_frame):
		fix_frames(frame, frame_index)
		reconcile_differences()
	
	frames = frames.slice(frame_index) as Array[Array]


## Creates a frame using current values.
func get_current_frame() -> Array:
	var frame : Array = Array()
	frame.resize(1)
	frame[FRAME] = GlobalParams.get_frame_time()
	return frame


## Compare two frames to see if they are within acceptable differences.
func frames_are_equal(_frame: Array, _to_compare: Array) -> bool:
	return true


## Fix all frames after the newly added [param frame] at the given [param index].
func fix_frames(_frame: Array, _index: int):
	pass


## Reconcile any differences after updating and fixing frames.
func reconcile_differences():
	pass

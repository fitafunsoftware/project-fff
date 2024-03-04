extends Control
## Simple script for the MainGame scene.
##
## Just meant to hold the game nodes. Starts the starting_scene when ready.

## Scene to start at the begining.
@export_file("*.tscn") var starting_scene

var _joypad_scene : String = ""


func _ready():
	$GameViewportContainer.start_scene(starting_scene)
	GlobalTouchScreen._load_joypad_scene = load_joypad_scene


## Load a scene to be the Virtual Joypad scene.
func load_joypad_scene(joypad_scene: String):
	if not _joypad_scene.is_empty():
		return
	
	ResourceQueue.queue_resource(joypad_scene)
	if ResourceQueue.is_ready(joypad_scene):
		_add_joypad_scene(joypad_scene)
	else:
		_joypad_scene = joypad_scene
		ResourceQueue.resource_loaded.connect(_joypad_scene_is_loaded)


# Helper functions
func _add_joypad_scene(joypad_scene: String):
	var scene : Resource = ResourceQueue.get_resource(joypad_scene)
	var virtual_joypad : Control = scene.instantiate()
	var previous_joypad : Control = find_child("VirtualJoypad", false, false)
	if previous_joypad:
		remove_child(previous_joypad)
		previous_joypad.queue_free()
	add_child(virtual_joypad, true)
	virtual_joypad.name = "VirtualJoypad"


# Signal functions
func _joypad_scene_is_loaded(scene: String):
	if not scene == _joypad_scene:
		return
	
	_add_joypad_scene(_joypad_scene)
	ResourceQueue.resource_loaded.disconnect(_joypad_scene_is_loaded)
	_joypad_scene = ""

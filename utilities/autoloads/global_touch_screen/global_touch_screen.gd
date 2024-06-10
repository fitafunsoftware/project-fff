extends Node
## Autoload for touch screen functionality.
##
## The autoload for handling showing or hiding of the virtual joypad. Also loads
## and saves joypads between sessions.

## Signal when touch screen is visible.
signal touch_screen_visible()
## Signal when touch screen is hidden.
signal touch_screen_hidden()

## The default joypad to use when the game is first run.
const DEFAULT_JOYPAD := "res://utilities/ui/virtual_joypad/virtual_joypad.tscn"
## Max number of event_index.
const MAX_EVENT_INDICES = 32

## Is touch screen joypad active.
var active : bool = false :
	set(value):
		active = value
		if _visible and not active:
			touch_screen_hidden.emit()
		if _visible and active:
			touch_screen_visible.emit()

# Is touch screen visible.
var _visible : bool = true
# Callable to load the joypad scene. MainGame actually handles adding the joypad
# scene to the tree.
var _load_joypad_scene : Callable
# Unused indices for event_index in InputEventAction.
var _indices : Array
# Dictionary of actions and their associated event_index.
var _event_indices : Dictionary


func _ready():
	if _load_joypad_scene:
		_load_joypad_scene.call(DEFAULT_JOYPAD)
	else:
		load_joypad.call_deferred(DEFAULT_JOYPAD)
	
	_indices = Array()
	for index in MAX_EVENT_INDICES:
		_indices.append(MAX_EVENT_INDICES - index - 1)
	
	_event_indices = Dictionary()


## Set the visibility of the touch screen joypad. If touch screen joypad is not 
## active, visibility is still set, but touch screen will always be hidden.
func set_visible(visible: bool):
	_visible = visible
	if active:
		if visible:
			touch_screen_visible.emit()
		else:
			touch_screen_hidden.emit()


## Get the visibility of the touch screen joypad based on if active and visible.
func get_visible() -> bool:
	return _visible and active


## Loads a joypad scene as your joypad.
func load_joypad(joypad_scene: String):
	if not _load_joypad_scene:
		return
	_load_joypad_scene.call(joypad_scene)


## Get the associated event_index for action. New event_index is assigned if it
## hasn't been assigned. Returns -1 if all event_index values are used.
func get_event_index(action: StringName) -> int:
	if not _event_indices.has(action):
		if _indices.is_empty():
			return -1
		_event_indices[action] = _indices.pop_back()
	
	return _event_indices[action]


## Frees up the associated event_index for action.
func remove_event_index(action: StringName):
	if not _event_indices.has(action):
		return
	
	_indices.push_front(_event_indices[action])
	_event_indices.erase(action)

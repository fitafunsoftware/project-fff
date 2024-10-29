extends Node
## Helper node for scene changing.
##
## New scenes are added to the tree through this node. Current scenes are siblings
## to this node, but lower down the tree so they are rendered above this scene.
## When the next scene is ready, the [GameViewport] is signalled to change scenes.

## Signal for when the next scene is ready.
signal next_scene_ready(next_scene: Node)
## Show virtual joypad?
var touch_controls: bool = false

var _next_scene: Node


## Ready the next scene to be changed to.
func ready_next_scene(next_scene: Node):
	_next_scene = next_scene
	_next_scene.ready.connect(_on_next_scene_ready)
	add_child(_next_scene)


# Function for when the next scene is ready.
func _on_next_scene_ready():
	_next_scene.ready.disconnect(_on_next_scene_ready)
	next_scene_ready.emit(_next_scene)
	_next_scene = null
	GlobalTouchScreen.set_visible(touch_controls)

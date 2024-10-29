extends Control
## Basic loading scene node.
##
## Just a generic loading scene to show while waiting for the next scene to load.

## The next scene to load.
@export_file("*.tscn") var next_scene: String
## Does the next scene need touch controls.
@export var touch_controls: bool = false


func _ready():
	get_viewport().change_scene.call_deferred(next_scene, touch_controls)

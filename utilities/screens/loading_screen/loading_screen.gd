extends Control
## Basic loading scene node.
##
## Just a generic loading scene to show while waiting for the next scene to load.

## The next scene to load.
@export_file("*.tscn") var next_scene : String



func _ready():
	get_viewport().change_scene.call_deferred(next_scene)

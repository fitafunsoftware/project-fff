extends Control
## Simple script for the MainGame scene.
##
## Just meant to hold the game nodes. Starts the starting_scene when ready.

## Scene to start at the begining.
@export_file("*.tscn") var starting_scene


func _ready():
	$GameViewportContainer.start_scene(starting_scene)

@tool
class_name MenuOption
extends Resource
## Resource for menu option data.
##
## Menu option data for creating menu buttons.

## Name for the option.
@export var name: String :
	set(value):
		name = value
		set_name(name)
## Path for the scene to be loaded.
@export_file("*.tscn") var scene: String
## Is loading screen used?
@export var load_scene: bool
## Is touch controls enabled for the scene to be loaded?
@export var touch: bool

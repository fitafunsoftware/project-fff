extends Control

@export_file("*.tscn") var starting_scene


func _ready():
	$GameViewportContainer.start_scene(starting_scene)

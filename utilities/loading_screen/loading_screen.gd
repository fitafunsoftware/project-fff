extends Control

@export_file("*.tscn") var next_scene : String


func _ready():
	get_viewport().change_scene(next_scene)

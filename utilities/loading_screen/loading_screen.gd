extends Control

@export_file("*.tscn") var next_scene : String


func _ready():
	get_viewport().change_scene.call_deferred(next_scene)

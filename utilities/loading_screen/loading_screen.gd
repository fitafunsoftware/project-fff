extends Control

@export_file("*.tscn") var next_scene : String


func _ready():
	get_viewport().queue_scene(next_scene)


func _process(_delta):
	if ResourceQueue.is_ready(next_scene):
		_change_scene()


func _change_scene():
	get_viewport().change_scene(next_scene)

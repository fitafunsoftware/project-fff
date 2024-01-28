extends Control

@export_file("*.tscn") var previous_scene


func _ready():
	get_viewport().queue_scene(previous_scene)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_go_back()

 
func _go_back():
	GlobalSettings.save_settings()
	get_viewport().change_scene(previous_scene)


func _on_back_pressed():
	_go_back()

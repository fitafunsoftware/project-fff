extends Node


func _input(event) -> void:
	if event.is_action_pressed("start"):
		if Input.is_action_pressed("back"):
			_exit()
	
	if event.is_action_pressed("back"):
		if Input.is_action_pressed("start"):
			_exit()


func _exit() -> void:
	get_viewport().set_input_as_handled()
	get_tree().unload_current_scene()
	get_tree().change_scene_to_file("res://scenes/exit_scene.tscn")
	queue_free()

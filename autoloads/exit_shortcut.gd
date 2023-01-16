extends Node


func _input(event) -> void:
	if event.is_action_pressed("start"):
		if Input.is_action_pressed("back"):
			_exit()
	
	if event.is_action_pressed("back"):
		if Input.is_action_pressed("start"):
			_exit()


func _exit() -> void:
	get_tree().set_input_as_handled()
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

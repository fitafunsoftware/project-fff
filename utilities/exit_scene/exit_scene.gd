extends Control

@export_file("*.tscn") var starting_scene : String


func _ready():
	match OS.get_name():
		"iOS":
			get_viewport().change_scene.call_deffered(starting_scene)
		"Android":
			get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
			get_tree().quit()
		_:
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()

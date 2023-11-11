extends Control

@export_file("*.tscn") var starting_scene : String


func _ready():
	if OS.get_name() in ["Android", "iOS"]:
		get_viewport().change_scene.call_deferred(starting_scene)
	else:
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

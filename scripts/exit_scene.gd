extends Node


func _ready():
	if OS.get_name() == "Android":
		get_tree().get_root().propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	else:
		get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
	get_tree().quit()

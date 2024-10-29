extends Control
## Script for the exit scene.
##
## Instead of having exit code split apart, any scene that needs to exit the
## game should load this scene instead. Code for handling exit notifications
## will be here.

@export_file("*.tscn") var starting_scene: String


# Propagate exit notifications.
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

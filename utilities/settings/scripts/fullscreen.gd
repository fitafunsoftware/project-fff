extends Control

@onready var _background = $Background
@onready var _enabled = $HBoxContainer/Enabled


func _ready():
	_set_enabled()


func _gui_input(event):
	if event.is_action_pressed("ui_accept"):
		accept_event()
		if _enabled.disabled:
			return
		_enabled.button_pressed = not _enabled.button_pressed


func _set_enabled():
	_enabled.button_pressed = GlobalSettings.fullscreen
	# This setting can't be changed on these platforms.
	_enabled.disabled = OS.get_name() in ["Android", "iOS", "Web"]


func _set_fullscreen(enabled: bool):
	GlobalSettings.fullscreen = enabled


# Signals
func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_enabled_toggled(toggled_on: bool):
	_set_fullscreen(toggled_on)
	grab_focus()

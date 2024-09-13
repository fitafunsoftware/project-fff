extends PanelContainer

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
	_enabled.button_pressed = GlobalSettings.touch_controls


func _set_touch_controls(enabled: bool):
	GlobalSettings.touch_controls = enabled


# Signals
func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_enabled_toggled(toggled_on: bool):
	_set_touch_controls(toggled_on)
	grab_focus()

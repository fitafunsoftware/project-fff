extends PanelContainer

@onready var _background = $Background
@onready var _enabled = $HBoxContainer/Enabled


func _ready():
	_set_enabled()
	if OS.has_feature("web") or OS.has_feature("mobile"):
		hide()


func _gui_input(event):
	if event.is_action_pressed("ui_accept"):
		accept_event()
		if _enabled.disabled:
			return
		_enabled.button_pressed = not _enabled.button_pressed


func _set_enabled():
	_enabled.button_pressed = GlobalSettings.vsync
	# This setting can't be changed on these platforms.
	_enabled.disabled = OS.has_feature("mobile") or OS.has_feature("web")


func _set_vsync(enabled: bool):
	GlobalSettings.vsync = enabled


# Signals
func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_enabled_toggled(toggled_on: bool):
	_set_vsync(toggled_on)
	grab_focus()

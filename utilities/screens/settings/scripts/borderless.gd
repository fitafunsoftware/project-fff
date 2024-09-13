extends PanelContainer

@onready var _background = $Background
@onready var _label = $HBoxContainer/Label
@onready var _enabled = $HBoxContainer/Enabled


func _ready():
	_set_enabled()
	GlobalSettings.window_properties_changed.connect(_set_enabled)
	if OS.has_feature("web") or OS.has_feature("mobile"):
		hide()


func _gui_input(event):
	if event.is_action_pressed("ui_accept"):
		accept_event()
		if _enabled.disabled:
			return
		_enabled.button_pressed = not _enabled.button_pressed


func _set_enabled():
	_enabled.button_pressed = GlobalSettings.borderless
	# This setting can't be changed on these platforms.
	_enabled.disabled = OS.has_feature("mobile") or OS.has_feature("web")
	_update_text()


func _set_borderless(enabled: bool):
	GlobalSettings.borderless = enabled


# Signals
func _update_text():
	if GlobalSettings.fullscreen:
		_label.text = "Exclusive Fullscreen :"
	else:
		_label.text = "Borderless :"


func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_enabled_toggled(toggled_on: bool):
	_set_borderless(toggled_on)
	grab_focus()

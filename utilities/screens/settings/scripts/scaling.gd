extends PanelContainer

const PREVIOUS : int = -1
const NEXT : int = 1

@onready var _background = $Background
@onready var _value = $HBoxContainer/Control/Control/Value
@onready var _previous = $HBoxContainer/Control/Previous
@onready var _next = $HBoxContainer/Control/Next


func _ready():
	get_viewport().size_changed.connect(_on_viewport_resized)
	GlobalSettings.scaling_changed.connect(_on_scaling_changed)
	var scaling = GlobalSettings.scaling
	_update_buttons(scaling)
	_update_text()


func _gui_input(event: InputEvent):
	var offset : int = 0
	offset -= int(event.is_action_pressed("ui_left"))
	offset += int(event.is_action_pressed("ui_right"))
	
	if offset != 0:
		accept_event()
		if (_previous.disabled and offset == PREVIOUS) \
				or (_next.disabled and  offset == NEXT):
			return
		set_scaling(offset)


# Due to to going from biggest to smallest, offset is subtracted from scaling
func set_scaling(offset: int):
	GlobalSettings.scaling = GlobalSettings.scaling - offset


func _update_text():
	# Get the size of the viewport container instead of the viewport itself.
	var viewport_size : Vector2i = get_viewport().get_parent().size
	_value.text = "%d x %d" % [viewport_size.x, viewport_size.y]


func _update_buttons(scaling: int):
	var allowed_scalings : Array = GlobalSettings.get_allowed_scalings()
	if scaling > allowed_scalings.back():
		GlobalSettings.scaling = scaling
		return
	
	# Due to going from biggest to smallest, previous is disabled for the
	# biggest scale and next is disabled for the smallest scale.
	_previous.disabled = scaling == allowed_scalings.back()
	_next.disabled = scaling == allowed_scalings.front()


# Signals
func _on_scaling_changed(scaling: int):
	_update_buttons(scaling)
	_update_text()


func _on_viewport_resized():
	var scaling : int = GlobalSettings.scaling
	_update_buttons(scaling)
	_update_text()


func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_previous_pressed():
	set_scaling(PREVIOUS)
	grab_focus()


func _on_next_pressed():
	set_scaling(NEXT)
	grab_focus()

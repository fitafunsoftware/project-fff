extends PanelContainer

const ASPECT_RATIO: PackedStringArray = [
	"Auto",
	"16 : 9",
	"16 : 10",
	"3 : 2",
	"4 : 3",
]

const PREVIOUS: int = -1
const NEXT: int = 1

@onready var _background = $Background
@onready var _value = $HBoxContainer/Control/Control/Value
@onready var _previous = $HBoxContainer/Control/Previous
@onready var _next = $HBoxContainer/Control/Next


func _ready():
	get_window().size_changed.connect(_on_window_size_changed)
	_on_aspect_ratio_changed(GlobalSettings.aspect_ratio)
	GlobalSettings.aspect_ratio_changed.connect(_on_aspect_ratio_changed)
	grab_focus.call_deferred()


func _gui_input(event: InputEvent):
	var offset: int = 0
	offset -= int(event.is_action_pressed("ui_left"))
	offset += int(event.is_action_pressed("ui_right"))
	
	if offset != 0:
		accept_event()
		if (_previous.disabled and offset == PREVIOUS) \
				or (_next.disabled and  offset == NEXT):
			return
		set_aspect_ratio(offset)


func set_aspect_ratio(offset: int):
	var allowed_aspect_ratios: Array = GlobalSettings.get_allowed_aspect_ratios()
	var index: int = allowed_aspect_ratios.find(GlobalSettings.aspect_ratio)
	GlobalSettings.aspect_ratio = allowed_aspect_ratios[index + offset]


# Signals
func _on_window_size_changed():
	_on_aspect_ratio_changed(GlobalSettings.aspect_ratio)


func _on_aspect_ratio_changed(aspect_ratio: int):
	_value.text = ASPECT_RATIO[aspect_ratio]
	var allowed_aspect_ratios: Array = GlobalSettings.get_allowed_aspect_ratios()
	_previous.disabled = aspect_ratio == allowed_aspect_ratios.front()
	_next.disabled = aspect_ratio == allowed_aspect_ratios.back()


func _on_focus_entered():
	_background.show()


func _on_focus_exited():
	_background.hide()


func _on_previous_pressed():
	set_aspect_ratio(PREVIOUS)
	grab_focus()


func _on_next_pressed():
	set_aspect_ratio(NEXT)
	grab_focus()

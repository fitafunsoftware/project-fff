extends PanelContainer

signal amount_changed(amount: int)

@export var title: String = "Title"
@export var max_value: int = 640
@export var min_value: int = 2
@export var is_tenth: bool = false

var amount: int = 0:
	set(value):
		amount = clampi(value, min_value, max_value)
		if _amount_label:
			_update_amount_label()
		amount_changed.emit(amount)

@onready var _amount_label: Label = $VBoxContainer/HBox/Amount

func _ready() -> void:
	_update_amount_label()
	$VBoxContainer/Title.text = title


func _update_amount_label():
	if not is_tenth:
		_amount_label.text = "%d" % amount
	else:
		@warning_ignore("integer_division")
		var integer: int = amount / 10
		var fractional: int = posmod(amount, 10)
		_amount_label.text = "%d.%d" % [integer, fractional]


func _increment(value: int) -> void:
	amount += value

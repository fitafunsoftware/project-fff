extends VBoxContainer

var is_in_range: bool = false

@onready var _score: Label = $Score

var _time: float = 0.0
var _text: String = "%.2f"


func _physics_process(delta: float) -> void:
	if is_in_range:
		_time += delta
		_score.text = _text % _time

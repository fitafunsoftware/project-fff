extends VBoxContainer

var is_in_range: bool = false

@onready var _score: Label = $Score
@onready var _total: Label = $Total

var _time: float = 0.0
var _text: String = "%.2f"
var _total_time: float = 0.0


func _physics_process(delta: float) -> void:
	_total_time += delta
	_total.text = _text % _total_time
	
	if is_in_range:
		_time += delta
		_score.text = _text % _time

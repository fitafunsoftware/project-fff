extends Area2D

@onready var _ranges: Array[CollisionShape2D] = [
	$Range0,
	$Range1,
	$Range2,
	$Range3,
	$Range4
]


func activate_hitbox(id: int) -> void:
	if id >= _ranges.size():
		return
	
	_ranges[id].disabled = false


func deactivate_hitbox(id: int) -> void:
	if id >= _ranges.size():
		return
	
	_ranges[id].disabled = true


func deactivate_all_hitboxes() -> void:
	for id in _ranges.size():
		_ranges[id].disabled = true

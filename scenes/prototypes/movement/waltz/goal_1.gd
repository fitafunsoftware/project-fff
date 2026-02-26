@tool
extends "res://scenes/prototypes/movement/waltz/goal_base.gd"

@export_category("Movement Logic")
@export var max_rest_duration: float = 2.0
@export var sprint_probability: float = 0.2


func start_move() -> void:
	_next_move()


func _next_move() -> void:
	var next_position: int = _get_new_position()
	var goal_position: int = int(position.x)
	var distance: int = abs(next_position - goal_position)
	var duration: float = float(distance) / base_speed
	
	direction = signi(next_position - goal_position)
	is_sprinting = randf() < sprint_probability
	await get_tree().create_timer(duration).timeout
	
	var rest_duration: float = \
			clampf(randfn(max_rest_duration*3.0/4.0, 1.0), 0.0, max_rest_duration)
	direction = 0
	is_sprinting = false
	await get_tree().create_timer(rest_duration).timeout
	
	_next_move()


func _get_new_position() -> int:
	return (randi() % (MAX_RANGE*2)) - MAX_RANGE

extends Node2D

@export var time_to_start: float = 1.0

@onready var _goal: Node2D = $Goal
@onready var _scoreboard: Control = $Scoreboard


func _ready() -> void:
	_start()


func _start() -> void:
	await get_tree().create_timer(time_to_start).timeout
	_goal.start_move()


func _player_entered() -> void:
	_scoreboard.is_in_range = true


func _player_exited() -> void:
	_scoreboard.is_in_range = false

extends Node2D

@export var max_range: int = 480
@export var player_speed: float = 100.0
@export var enemy_speed: float = 120.0

@onready var player: Node2D = %Player

# Player private variables
var _player_direction: int = 0

# Enemy private variables
var _enemy_direction: int = 0 

func _ready():
	pass


func _physics_process(delta: float):
	_set_player_direction()
	_move_player(delta)
	_clamp_player_position()


func _set_player_direction():
	var input: float = round(
		Input.get_axis(&"leftxn", &"leftxp") + Input.get_axis(&"dpleft", &"dpright")
		)
	_player_direction = int(input)


func _move_player(delta: float):
	var current_speed: float = \
			enemy_speed * _enemy_direction + \
			player_speed * _player_direction
	
	player.position.x += current_speed * delta


func _clamp_player_position():
	var x_position: float = player.position.x
	x_position = clampf(x_position, 0.0, max_range)
	player.position.x = x_position

extends Node2D

@export var max_range: int = 480:
	set(value):
		max_range = value
		player.max_range = value
@export var player_speed: float = 100.0:
	set(value):
		player_speed = value
		player.speed = value
@export var enemy_towards_speed: float = 150.0
@export var enemy_away_speed: float = 75.0

@onready var player: Node2D = $Player

@onready var enemy_towards: Node2D = $WolfArrows/Towards
@onready var enemy_away: Node2D = $WolfArrows/Away
@onready var enemy_stay: Node2D = $WolfArrows/Stay


# Enemy private variables
const TOWARDS: int = -1
const AWAY: int = 1
var _range_divisions: float = 100.0
var _in_action: bool = false
var _move_duration: float = 1.2
var _default_stay_duration: float = 1.0


func _ready():
	player.speed = player_speed
	player.max_range = max_range
	player.enemy_speed = enemy_towards_speed
	player.enemy_direction = 0
	enemy_towards.hide()
	enemy_away.hide()
	enemy_stay.hide()


func _physics_process(_delta: float):
	_process_enemy_state()


func _process_enemy_state():
	if _in_action:
		return
	
	var range_method: String = "_range_%d" % _get_player_range()
	
	if has_method(range_method):
		call(range_method)
	else:
		_range_default()


# Enemy range methods
func _range_0():
	_move_away_from_player()


func _range_1():
	_stay(_default_stay_duration)


func _range_2():
	_stay(_default_stay_duration)


func _range_3():
	_move_towards_player()


func _range_4():
	_move_towards_player()


func _range_5():
	_move_towards_player()


func _range_default():
	_stay(_default_stay_duration)


func _get_player_range() -> int:
	return floori(player.position.x/_range_divisions)


func _stay(duration: float):
	_in_action = true
	enemy_stay.show()
	
	await get_tree().create_timer(duration).timeout
	
	_reset_action()


func _move_towards_player():
	_in_action = true
	player.enemy_speed = enemy_towards_speed
	player.enemy_direction = TOWARDS
	enemy_towards.show()
	
	await get_tree().create_timer(_move_duration).timeout
	
	_reset_action()

func _move_away_from_player():
	_in_action = true
	player.enemy_speed = enemy_away_speed
	player.enemy_direction = AWAY
	enemy_away.show()
	
	await get_tree().create_timer(_move_duration).timeout
	
	_reset_action()


func _reset_action():
	player.enemy_direction = 0
	_in_action = false
	enemy_towards.hide()
	enemy_away.hide()
	enemy_stay.hide()

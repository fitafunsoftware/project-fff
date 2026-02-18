@tool
extends Node2D


@export var size: int = 80:
	set(value):
		size = clampi(value, 2, 640)
		if _goal:
			_goal.size = size
@export var base_speed: int = 128
@export var sprint_ratio: float = 1.5


@onready var _goal: Node2D = $Goal


func _ready() -> void:
	if _goal:
		_goal.size = size
	
	if not Engine.is_editor_hint():
		return
	
	if _goal:
		_goal.base_speed = base_speed
		_goal.sprint_ratio = sprint_ratio

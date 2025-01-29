class_name Blackboard
extends Node

var _level: LevelBlackboard
var _entity: EntityBlackboard


func _ready():
	_append_blackboards()


func _append_blackboards():
	_level = LevelBlackboard.new()
	_entity = EntityBlackboard.new()
	
	add_child(_level)
	add_child(_entity)

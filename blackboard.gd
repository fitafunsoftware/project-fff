class_name Blackboard
extends Node

var _level: LevelBlackboard
var _entity: EntityBlackboard


func _ready():
	_append_blackboards()


func get_entities_in_level(level_id: int) -> Array[int]:
	return _level.get_entities_in_level(level_id)


func get_entity_spawn_request(entity_id: int) -> EntitySpawnRequest:
	return _entity.get_entity_spawn_request(entity_id)


func _append_blackboards():
	_level = LevelBlackboard.new()
	_entity = EntityBlackboard.new()
	
	add_child(_level)
	add_child(_entity)

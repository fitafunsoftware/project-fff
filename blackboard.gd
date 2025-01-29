extends Node

var _level: LevelBlackboard
var _entity: EntityBlackboard


func _ready():
	_append_blackboards()


func get_entities_in_level(level_id: int) -> Array[int]:
	return _level.get_entities_in_level(level_id)


func add_entity_to_level(level_id: int, entity_id: int):
	_level.add_entity_to_level(level_id, entity_id)


func erase_entity_from_level(level_id: int, entity_id: int):
	_level.erase_entity_from_level(level_id, entity_id)


func get_entity_spawn_request(entity_id: int) -> EntitySpawnRequest:
	return _entity.get_entity_spawn_request(entity_id)


func add_entity_spawn_request(entity_id: int, spawn_request: EntitySpawnRequest):
	_entity.add_entity_spawn_request(entity_id, spawn_request)


func erase_entity(entity_id: int):
	_entity.erase_entity(entity_id)


func _append_blackboards():
	_level = LevelBlackboard.new()
	_entity = EntityBlackboard.new()
	
	add_child(_level)
	add_child(_entity)

extends Node

var _level: LevelBlackboard
var _entity: EntityBlackboard


func _ready():
	_append_blackboards()


# LevelBlackboard
func get_entity_level(entity_id: int) -> int:
	return _level.get_entity_level(entity_id)


func get_entities_in_level(level_id: int) -> Array[int]:
	return _level.get_entities_in_level(level_id)


func add_entity_to_level(level_id: int, entity_id: int):
	_level.add_entity_to_level(level_id, entity_id)


func add_entities_to_level(level_id: int, entity_ids: Array[int]):
	_level.add_entities_to_level(level_id, entity_ids)


func erase_level(level_id: int):
	_level.erase_level(level_id)


func remove_entity_from_level(level_id: int, entity_id: int):
	_level.remove_entity_from_level(level_id, entity_id)


# EntityBlackboard
func get_entity_spawn_request(entity_id: int) -> EntitySpawnRequest:
	return _entity.get_entity_spawn_request(entity_id)


func add_entity_spawn_request(entity_id: int, spawn_request: EntitySpawnRequest):
	_entity.add_entity_spawn_request(entity_id, spawn_request)


# Mixed functions.
func erase_entity(entity_id: int):
	_level.erase_entity(entity_id)
	_entity.erase_entity(entity_id)


func erase_level_and_entities(level_id: int):
	var entity_ids: Array[int] = _level.get_entities_in_level(level_id)
	for entity_id: int in entity_ids:
		_entity.erase_entity(entity_id)
	_level.erase_level_and_entities(level_id)


# Helper functions.
func _append_blackboards():
	_level = LevelBlackboard.new()
	_entity = EntityBlackboard.new()
	
	add_child(_level)
	add_child(_entity)

class_name LevelBlackboard
extends Node

const NO_LEVEL_ID = -1

var _level_entities: Dictionary[int, Array]
var _entities_level: Dictionary[int, int]


func get_entity_level(entity_id: int) -> int:
	if not _entities_level.has(entity_id):
		return NO_LEVEL_ID
	
	return _entities_level[entity_id]


func get_entities_in_level(level_id: int) -> Array[int]:
	if _level_entities.has(level_id):
		return _level_entities[level_id] as Array[int]
	
	return Array([], TYPE_INT, "", null)


func add_entity_to_level(level_id: int, entity_id: int):
	var level_entities: Array[int] = _level_entities.get_or_add(level_id,
			Array([], TYPE_INT, "", null)) as Array[int]
	_add_entity_to_level(level_id, entity_id, level_entities)


func add_entities_to_level(level_id: int, entity_ids: Array[int]):
	var level_entities: Array[int] = _level_entities.get_or_add(level_id,
			Array([], TYPE_INT, "", null)) as Array[int]
	for entity_id: int in entity_ids:
		_add_entity_to_level(level_id, entity_id, level_entities)


func erase_level(level_id: int):
	if not _level_entities.has(level_id):
		return
	
	for entity_id: int in _level_entities[level_id]:
		_entities_level.erase(entity_id)
	
	_level_entities.erase(level_id)


func remove_entity_from_level(level_id: int, entity_id: int):
	if _level_entities.has(level_id):
		if not _level_entities[level_id].has(entity_id):
			return
		
		_erase_entity_from_current_level(entity_id)
		_entities_level.erase(entity_id)


func erase_entity(entity_id: int):
	if not _entities_level.has(entity_id):
		return
	
	_erase_entity_from_current_level(entity_id)
	_entities_level.erase(entity_id)


# Helper Functions
func _erase_entity_from_current_level(entity_id: int):
	var level_id = _entities_level[entity_id]
	_level_entities[level_id].erase(entity_id)


func _add_entity_to_level(level_id: int, entity_id: int, level_entities: Array[int]):
	if _entities_level.has(entity_id):
		if _entities_level[entity_id] == level_id:
			return
		_erase_entity_from_current_level(entity_id)
	
	level_entities.append(entity_id)
	_entities_level[entity_id] = level_id

class_name LevelBlackboard
extends Node

var _level_entities: Dictionary[int, Array]


func get_entities_in_level(level_id: int) -> Array[int]:
	if _level_entities.has(level_id):
		return _level_entities[level_id] as Array[int]
	
	return Array() as Array[int]


func add_entity_to_level(level_id: int, entity_id: int):
	var entities: Array[int] = _level_entities.get_or_add(level_id, Array([], TYPE_INT, "", null))
	if not entities.has(entity_id):
		entities.append(entity_id)


func erase_entity_from_level(level_id: int, entity_id: int):
	if _level_entities.has(level_id):
		var entities: Array[int] = _level_entities[level_id] as Array[int]
		entities.erase(entity_id)

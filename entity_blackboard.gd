class_name EntityBlackboard
extends Node

var _spawn_requests: Dictionary[int, EntitySpawnRequest]


func get_entity_spawn_request(entity_id: int) -> EntitySpawnRequest:
	if _spawn_requests.has(entity_id):
		return _spawn_requests[entity_id]
	
	return null


func add_entity_spawn_request(entity_id: int, spawn_request: EntitySpawnRequest):
	_spawn_requests[entity_id] = spawn_request


func erase_entity(entity_id: int):
	_spawn_requests.erase(entity_id)


func entity_exists(entity_id: int) -> bool:
	return _spawn_requests.has(entity_id)

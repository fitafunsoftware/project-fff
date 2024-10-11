class_name EntitySpawner
extends Node3D
## Helper node to handle spawning entities.
##
## A helper node that handles spawning entities especially in multiplayer. Spawns entities as
## children of this node.

# List of descendant entities.
var _entity_list: Dictionary[int, Entity]


func _ready():
	add_to_group(GlobalEntitySpawner.ENTITY_SPAWNER_GROUP)
	_populate_entity_list()


## Request for an entity to be spawned. Entity is hidden before and shown after applying functions
## and adding to tree.
func spawn_entity(spawn_request: EntitySpawnRequest):
	var entity: Entity = GlobalEntitySpawner._spawn_entity_to(self, spawn_request)
	_entity_list[entity.entity_id] = entity
	GlobalEntitySpawner.register_entity(entity.entity_id, self)


## Sync entity with server. Used for multiplayer.
func sync_entity(entity_id: int):
	# Syncing entity that was already spawned previously.
	var _entity: Entity = _entity_list[entity_id]


## Free entity that was spawned previously. Called by the server.
func free_entity(entity_id: int):
	# Locally, entities should not be freed (destroyed), just hidden, until the server allows it.
	if _entity_list.has(entity_id):
		var entity: Entity = _entity_list[entity_id]
		entity.queue_free()
		_entity_list.erase(entity_id)


## Get list of entity ids that are descendants of this spawner.
func get_entity_ids() -> Array[int]:
	var entity_ids: Array[int]
	entity_ids.assign(_entity_list.keys())
	return entity_ids


# Populate list of descendant entities.
func _populate_entity_list():
	var list: Dictionary = _recursive_populate_list(self)
	_entity_list.assign(list)


# Recursive helper function to find Entity nodes and add to returned Dictionary.
func _recursive_populate_list(node: Node) -> Dictionary:
	var list: Dictionary = {}
	
	if node is Entity:
		list[node.entity_id] = node
	
	for child in node.get_children():
		list.merge(_recursive_populate_list(child))
	
	return list

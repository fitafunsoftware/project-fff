extends Node
## Global manager for EntitySpawners.
##
## Requests to spawn entities should go through this autoload and will be distributed to the proper
## EntitySpawner. Helps manage server requests to spawn and sync entities.

## Identifier for EntitySpawner group.
const ENTITY_SPAWNER_GROUP := &"entity_spawners"

# Gets the Array of nodes in the EntitySpawner group.
var _entity_spawners: Array[Node]:
	get:
		return _tree.get_nodes_in_group(ENTITY_SPAWNER_GROUP)

# Cache the SceneTree for getting group arrays.
@onready var _tree: SceneTree = get_tree()

# Cache of requestors that make spawn requests for future lookup.
var _requestor_cache: Dictionary[Node, EntitySpawner]
# Cache of entity ids and their respective EntitySpawner.
var _entity_ids: Dictionary[int, EntitySpawner]


func _ready():
	clear_caches()


## Clear the requestor cache and repopulate entity id cache.
func clear_caches():
	_requestor_cache.clear()
	_entity_ids.clear()
	_cache_entity_ids()


## Request for an entity to be spawned. Entity is hidden before and shown after adding to tree and
## applying functions. If no appropriate EntitySpawner can be found, entity is spawned as a sibling.
func spawn_entity(requestor: Node, spawn_request: EntitySpawnRequest):
	var entity_spawner: EntitySpawner = _get_ancestor_entity_spawner(requestor)
	
	if entity_spawner:
		# Move multiplayer spawn request handling to here?
		entity_spawner.spawn_entity(spawn_request)
	else:
		_spawn_entity_to(requestor.get_parent(), spawn_request)


## Register an entity id to given EntitySpawner.
func register_entity(entity_id: int, entity_spawner: EntitySpawner):
	_entity_ids[entity_id] = entity_spawner


## Sync an entity with the server.
func sync_entity(entity_id: int):
	if not _entity_ids.has(entity_id):
		return
	
	var entity_spawner: EntitySpawner = _entity_ids[entity_id]
	entity_spawner.sync_entity(entity_id)


# Logic for spawning entities to given parent node.
func _spawn_entity_to(parent: Node, spawn_request: EntitySpawnRequest) -> Entity:
	var resource: Resource = ResourceQueue.get_resource(spawn_request.entity_path)
	var entity: Entity = resource.instantiate()
	entity.entity_id = spawn_request.entity_id
	
	if multiplayer.is_server():
		# Server side spawning.
		pass
	else:
		# Client side spawning.
		pass
	
	entity.hide()
	for pre_add_function: EntityFunctionCall in spawn_request.pre_add_functions:
		entity.callv(pre_add_function.function, pre_add_function.arguments)
	
	parent.add_child(entity)
	
	for post_add_function: EntityFunctionCall in spawn_request.post_add_functions:
		entity.callv(post_add_function.function, post_add_function.arguments)
	
	for deferred_function: EntityFunctionCall in spawn_request.deferred_functions:
		entity.call_deferred("callv", deferred_function.function, deferred_function.arguments)
	entity.show()
	
	return entity


# Repopulate entity id cache.
func _cache_entity_ids():
	for entity_spawner: EntitySpawner in _entity_spawners:
		var entity_ids: Array[int] = entity_spawner.get_entity_ids()
		for entity_id: int in entity_ids:
			_entity_ids[entity_id] = entity_spawner


# Find corresponding EntitySpawner to node.
func _get_ancestor_entity_spawner(node: Node) -> EntitySpawner:
	if _requestor_cache.has(node):
		var entity_spawner: EntitySpawner = _requestor_cache[node]
		if entity_spawner:
			return _requestor_cache[node]
	
	for spawner: EntitySpawner in _entity_spawners:
		var ancestor: Node = node.find_parent(spawner.name)
		if is_same(ancestor, spawner):
			_requestor_cache[node] = spawner
			return spawner
	
	return null

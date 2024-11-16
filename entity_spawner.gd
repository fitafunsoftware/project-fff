class_name EntitySpawner
extends Node3D

@onready var requests: Dictionary = Dictionary()
@onready var entity_list: Dictionary = Dictionary()


func _ready():
	ResourceQueue.resource_loaded.connect(_spawn_entity)


func spawn_entity(spawn_request: EntitySpawnRequest):
	requests[spawn_request.entity_path] = spawn_request
	# Send this to the multiplayer to spawn to other clients.
	ResourceQueue.queue_resource(spawn_request.entity_path)


func _spawn_entity(entity_path: String):
	if not requests.has(entity_path):
		return
	
	var resource: Resource = ResourceQueue.get_resource(entity_path)
	var entity: Entity = resource.instantiate()
	var request: EntitySpawnRequest = requests[entity_path]
	var entity_id: int = 0 # Set the id later.
	
	if multiplayer.is_server():
		# Server side spawning.
		pass
	else:
		# Client side spawning.
		pass
	
	# Pre-add functions.
	for pre_add_function: EntityFunctionCall in request.pre_add_functions:
		entity.callv(pre_add_function.function, pre_add_function.arguments)
	
	add_child(entity)
	
	# Post-add functions.
	for post_add_function: EntityFunctionCall in request.post_add_functions:
		entity.callv(post_add_function.function, post_add_function.arguments)
	# Call-deferred functions.
	for deferred_function: EntityFunctionCall in request.deferred_functions:
		entity.call_deferred("callv", deferred_function.function, deferred_function.arguments)
	
	entity_list[entity_id] = entity


func sync_entity(entity_id: int):
	# Syncing entity that was already spawned previously.
	var entity: Entity = entity_list[entity_id]


func free_entity(entity_id: int):
	# Free an entity that was spawned previously. Called by the server.
	# Locally, entities should not be freed until the server allows it.
	if entity_list.has(entity_id):
		var entity: Entity = entity_list[entity_id]
		entity.queue_free()
		entity_list.erase(entity_id)

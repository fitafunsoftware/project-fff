class_name EntitySpawnRequest
## Resource for requesting to spawn an entity.

## Path to entity scene to spawn.
var entity_path: String
## List of functions to call before adding entity to tree.
var pre_add_functions: Array[EntityFunctionCall]
## List of functions to call after adding entity to tree.
var post_add_functions: Array[EntityFunctionCall]
## List of functions to call deferred.
var deferred_functions: Array[EntityFunctionCall]
## Id of the entity to spawn.
var entity_id: int = -1


@warning_ignore("SHADOWED_VARIABLE")
func _init(entity_path: String,
		pre_add_functions: Array[EntityFunctionCall] = Array([], TYPE_OBJECT, "RefCounted", EntityFunctionCall),
		post_add_functions: Array[EntityFunctionCall] = Array([], TYPE_OBJECT, "RefCounted", EntityFunctionCall),
		deferred_functions: Array[EntityFunctionCall] = Array([], TYPE_OBJECT, "RefCounted", EntityFunctionCall),
		entity_id: int = -1):
	self.entity_path = entity_path
	self.pre_add_functions = pre_add_functions
	self.post_add_functions = post_add_functions
	self.deferred_functions = deferred_functions
	self.entity_id = entity_id

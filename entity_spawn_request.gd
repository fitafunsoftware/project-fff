class_name EntitySpawnRequest

var entity_path: String
var pre_add_functions: Array[EntityFunctionCall]
var post_add_functions: Array[EntityFunctionCall]
var deferred_functions: Array[EntityFunctionCall]


func _init(entity_path: String,
		pre_add_functions: Array[EntityFunctionCall],
		post_add_functions: Array[EntityFunctionCall],
		deferred_functions: Array[EntityFunctionCall]):
	self.entity_path = entity_path
	self.pre_add_functions = pre_add_functions
	self.post_add_functions = post_add_functions
	self.deferred_functions = deferred_functions

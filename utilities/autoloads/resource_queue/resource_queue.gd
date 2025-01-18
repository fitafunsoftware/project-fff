extends Node
## An autoload to help handle the loading of resources.
##
## Queues up resources that need to be loaded. This autoload deals with the
## ResourceLoader Singleton. Handles the queueing, getting progress, checking
## if ready, and retrieval of resources.

## Signal to notify when a resource has been loaded.
signal resource_loaded(path: String)

# The pending resources to be loaded.
var _pending: PackedStringArray = []


# Checks if pending resources have been loaded.
func _process(_delta: float):
	if _pending.is_empty():
		return
	
	var to_clear: Array[int] = []
	for index: int in _pending.size():
		var path: String = _pending[index]
		if ResourceLoader.has_cached(_uid_to_path(path)):
			resource_loaded.emit(path)
			to_clear.append(index)
	
	to_clear.reverse()
	for index: int in to_clear:
		_pending.remove_at(index)


## Adds a resource to the queue to be loaded.
func queue_resource(path: String):
	if ResourceLoader.has_cached(_uid_to_path(path)):
		resource_loaded.emit(path)
	elif path in _pending:
		return
	
	var error: Error = ResourceLoader.load_threaded_request(path)
	if error == OK:
		_pending.append(path)


## Returns the load progress of a resource. Returns -1.0 if the resource has 
## not been queued.
func get_progess(path: String) -> float:
	var progress: float = -1.0
	if ResourceLoader.has_cached(_uid_to_path(path)):
		progress = 1.0
	elif path in _pending:
		var return_array: Array = []
		var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path, return_array)
		if status in [ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED]:
			progress = return_array[0]
	
	return progress


## Checks if a resource is loaded.
func is_ready(path: String) -> bool:
	if ResourceLoader.has_cached(_uid_to_path(path)):
		return true
	elif path in _pending:
		var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			return true
	
	return false


## Returns a resource that has been loaded. If the resource was not queued for 
## loading, the resource is loaded on the spot which can cause a lag spike.
func get_resource(path: String) -> Resource:
	if ResourceLoader.has_cached(_uid_to_path(path)):
		return ResourceLoader.load(path)
	elif path in _pending:
		var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
		if status in [ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED]:
			_pending.remove_at(_pending.find(path))
			return ResourceLoader.load_threaded_get(path)
	
	return load(path)


# Changes uid to a proper path for ResourceLoader.
func _uid_to_path(path: String) -> String:
	if path.begins_with("uid://"):
		var id: int = ResourceUID.text_to_id(path)
		if ResourceUID.has_id(id):
			return ResourceUID.get_id_path(id)
	
	return path

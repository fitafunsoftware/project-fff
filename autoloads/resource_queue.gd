extends Node

signal resource_loaded(path)

var _pending : PackedStringArray = []


func _process(_delta):
	if _pending.is_empty():
		return
	
	var to_clear : Array[int] = []
	for index in _pending.size():
		if ResourceLoader.has_cached(_pending[index]):
			resource_loaded.emit(_pending[index])
			to_clear.append(index)
	
	to_clear.reverse()
	for index in to_clear:
		_pending.remove_at(index)


func queue_resource(path: String):
	if ResourceLoader.has_cached(path):
		return
	elif path in _pending:
		return
	
	var error = ResourceLoader.load_threaded_request(path)
	if error == OK:
		_pending.append(path)


func get_progess(path: String) -> float:
	var progress : float = -1.0
	if ResourceLoader.has_cached(path):
		progress = 1.0
	elif path in _pending:
		var return_array : Array = []
		var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path, return_array)
		if status in [ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED]:
			progress = return_array[0]
	
	return progress


func is_ready(path: String) -> bool:
	if ResourceLoader.has_cached(path):
		return true
	elif path in _pending:
		var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			return true
	
	return false


func get_resource(path: String) -> Resource:
	if ResourceLoader.has_cached(path):
		return ResourceLoader.load(path)
	elif path in _pending:
		var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
		if status in [ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED]:
			_pending.remove_at(_pending.find(path))
			return ResourceLoader.load_threaded_get(path)
	
	return load(path)

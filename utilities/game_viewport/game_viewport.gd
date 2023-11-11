class_name GameViewport
extends SubViewport

var _loading_scene : Resource = preload("res://utilities/loading_screen/loading_screen.tscn")

@onready var next_scene_manager = $NextSceneManager

var _pending_path : String = ""


func _ready():
	next_scene_manager.next_scene_ready.connect(_on_next_scene_ready)
	ResourceQueue.resource_loaded.connect(_pending_path_loaded)


func queue_scene(path: String) -> void:
	ResourceQueue.queue_resource(path)


func change_scene(path: String) -> void:
	if not _pending_path.is_empty():
		return
	
	if not ResourceQueue.is_ready(path):
		queue_scene(path)
		_pending_path = path
		return
	
	_ready_scene_node(path)


func _ready_scene_node(path: String):
	var new_scene_resource: Resource = ResourceQueue.get_resource(path)
	var new_scene = new_scene_resource.instantiate()
	next_scene_manager.ready_next_scene(new_scene)


func change_to_loading_scene(path: String) -> void:
	var loading_screen = _loading_scene.instantiate()
	loading_screen.next_scene = path
	next_scene_manager.ready_next_scene(loading_screen)


func _pending_path_loaded(path: String):
	if _pending_path == path:
		_ready_scene_node(path)
		_pending_path = ""


func _on_next_scene_ready(next_scene: Node):
	for child in get_children():
		if not child in [next_scene, next_scene_manager]:
			child.queue_free()

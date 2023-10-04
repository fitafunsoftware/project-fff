class_name GameViewport
extends SubViewport

var _loading_scene : Resource = preload("res://utilities/loading_screen/loading_screen.tscn")

@onready var next_scene_manager = $NextSceneManager


func _ready():
	next_scene_manager.next_scene_ready.connect(_on_next_scene_ready)


func queue_scene(path: String) -> void:
	ResourceQueue.queue_resource(path)


func change_scene(path: String) -> void:
	var new_scene_resource: Resource = ResourceQueue.get_resource(path)
	
	if not new_scene_resource:
		return
	
	var new_scene = new_scene_resource.instantiate()
	ready_scene_node(new_scene)


func ready_scene_node(next_scene: Node):
	next_scene_manager.ready_next_scene(next_scene)


func change_to_loading_scene(path: String) -> void:
	var loading_screen = _loading_scene.instantiate()
	loading_screen.next_scene = path
	
	ready_scene_node(loading_screen)


func _on_next_scene_ready(next_scene: Node):
	for child in get_children():
		if not child in [next_scene, next_scene_manager]:
			child.queue_free()

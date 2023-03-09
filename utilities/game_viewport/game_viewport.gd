extends SubViewport
class_name GameViewport

var _loading_scene : Resource = preload("res://utilities/loading_screen/loading_screen.tscn")


func queue_scene(path: String) -> void:
	ResourceQueue.queue_resource(path)


func change_scene(path: String) -> void:
	var new_scene_resource: Resource = ResourceQueue.get_resource(path)
	
	if not new_scene_resource:
		return
	
	var new_scene = new_scene_resource.instantiate()
	change_scene_node(new_scene)


func change_scene_node(next_scene: Node):
	if get_child_count() > 0:
		get_child(0).queue_free()
	add_child(next_scene)


func change_to_loading_scene(path: String) -> void:
	var loading_screen = _loading_scene.instantiate()
	loading_screen.next_scene = path
	
	change_scene_node(loading_screen)

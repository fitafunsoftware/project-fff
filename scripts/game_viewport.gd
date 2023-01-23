extends SubViewport
class_name GameViewport


func change_scene_to_file(path: String) -> void:
	var new_scene_resource: Resource = load(path)
	
	if not new_scene_resource:
		return
	
	var new_scene = new_scene_resource.instantiate()
	
	get_child(0).queue_free()
	add_child(new_scene)

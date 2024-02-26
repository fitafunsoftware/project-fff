class_name GameViewport
extends SubViewport
## Main Viewport of the game.
## 
## This viewport manages scene switching and queuing scene resources.

# Generic loading scene in case any one scene takes too long to load.
var _loading_scene : Resource = preload("res://utilities/screens/loading_screen/loading_screen.tscn")

# A node that helps with the loading of the next scene. Notifies the viewport
# when the next scene is loaded.
@onready var _next_scene_manager = $NextSceneManager

# The path of the next scene that is currently loading.
var _pending_path : String = ""


func _ready():
	_next_scene_manager.next_scene_ready.connect(_on_next_scene_ready)
	ResourceQueue.resource_loaded.connect(_pending_path_loaded)


## Queue a scene to be loaded by the ResourceQueue. Does not change the scene.
func queue_scene(path: String) -> void:
	ResourceQueue.queue_resource(path)


## Change the current scene to the scene in path.
func change_scene(path: String) -> void:
	if not _pending_path.is_empty():
		return
	
	if not ResourceQueue.is_ready(path):
		queue_scene(path)
		_pending_path = path
		return
	
	_ready_scene_node(path)


# Instantiate the new scene and change to it when ready. NextSceneManager keeps
# the new scene behind the current one.
func _ready_scene_node(path: String):
	var new_scene_resource: Resource = ResourceQueue.get_resource(path)
	var new_scene = new_scene_resource.instantiate()
	_next_scene_manager.ready_next_scene(new_scene)


# Instantiate the loading scene and change to it when ready.
func change_to_loading_scene(path: String) -> void:
	var loading_screen = _loading_scene.instantiate()
	loading_screen.next_scene = path
	_next_scene_manager.ready_next_scene(loading_screen)


# Function for the ResourceQueue resource loaded signal. If the resource is the
# same as the pending path, ready the next scene to be changed to it.
func _pending_path_loaded(path: String):
	if _pending_path == path:
		_ready_scene_node(path)
		_pending_path = ""


# Function for the NextSceneManager next scene ready signal. Free the current
# scene and any other nodes. Add the next scene as a direct child.
func _on_next_scene_ready(next_scene: Node):
	for child in get_children():
		if not child in [_next_scene_manager]:
			child.queue_free()
	
	next_scene.reparent(self)

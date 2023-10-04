extends Node

signal next_scene_ready(next_scene)

var _next_scene : Node


func ready_next_scene(next_scene: Node):
	_next_scene = next_scene
	_next_scene.ready.connect(_on_next_scene_ready)
	add_child(_next_scene)


func _on_next_scene_ready():
	_next_scene.ready.disconnect(_on_next_scene_ready)
	_next_scene.reparent(get_parent())
	emit_signal("next_scene_ready", _next_scene)
	_next_scene = null

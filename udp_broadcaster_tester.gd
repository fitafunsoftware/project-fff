extends Control

@export_file("*.tscn") var previous_scene
@onready var local_server_broadcaster := LocalServerBroadcaster.new()

var broadcast_info : Dictionary = {
	"address": "192.168.1.12",
	"port": 6281,
	"connections": 1,
	"max_connections": 6,
	"extras": ["Testing", 5, "Passed."]
}


func _ready() -> void:
	get_viewport().queue_scene(previous_scene)
	add_child(local_server_broadcaster)
	local_server_broadcaster.set_broadcast_info(broadcast_info)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().change_scene(previous_scene)

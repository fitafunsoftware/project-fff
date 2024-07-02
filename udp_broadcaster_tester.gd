extends Control

@export_file("*.tscn") var previous_scene
@onready var local_server_broadcaster := LocalServerBroadcaster.new()


func _ready() -> void:
	get_viewport().queue_scene(previous_scene)
	add_child(local_server_broadcaster)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().change_scene(previous_scene)

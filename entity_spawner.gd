class_name EntitySpawner
extends Node3D


func spawn_entity(entity: String, arguments: Dictionary):
	if multiplayer.is_server():
		# Server side spawning.
		pass
	else:
		# Client side spawning.
		pass


func sync_entity(entity_id: int):
	# Syncing entity that was already spawned previously.
	pass

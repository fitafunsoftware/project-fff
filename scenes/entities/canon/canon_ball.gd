extends Entity

const DESTRUCTION_LAYERS := [8]


func _on_body_entered(body: Node3D):
	if body is PhysicsBody3D:
		for layer in DESTRUCTION_LAYERS:
			if body.get_collision_layer_value(layer):
				queue_free()
				break

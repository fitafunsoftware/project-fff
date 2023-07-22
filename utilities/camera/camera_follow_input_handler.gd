class_name CameraFollowInputHandler
extends Node

@export var body : Entity

var speed : float = 3.0
var leash_distance : Vector3 = Vector3.ZERO
var _target : Node3D :
	get = get_target, set = set_target


func _physics_process(delta):
	var target_velocity : Vector3 = _get_target_velocity(delta)
	
	body.set_target_velocity_2d(Vector2(target_velocity.x, target_velocity.z))
	body.set_y_velocity(target_velocity.y)


func _get_target_velocity(delta: float) -> Vector3:
	var displacement = _target.position - body.position
	var leashed_distance = displacement.abs() - leash_distance
	var leashed_displacement = displacement.sign() * \
			leashed_distance.clamp(Vector3.ZERO, Vector3.ONE * speed * delta)
	var target_velocity = leashed_displacement / delta
	return target_velocity


func get_target() -> Node3D:
	return _target


func set_target(node: Node3D):
	_target = node

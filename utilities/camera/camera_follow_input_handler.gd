class_name CameraFollowInputHandler
extends Node

@export var body : CameraFollowBody

var speed : float = 3.0
var leash_distance : Vector3 = Vector3.ZERO
var negative_y_leash_distance : float = 0.0
var _target : Node3D :
	get = get_target, set = set_target


func _physics_process(delta):
	var target_velocity : Vector3 = _get_target_velocity(delta)
	
	var velocity_2d = Vector2(target_velocity.x, target_velocity.z)
	
	body.target_velocity_2d = velocity_2d
	body.set_velocity_2d(velocity_2d)
	
	if _target is CharacterBody3D:
		if _target.is_on_floor() and not body.is_on_floor():
			if is_zero_approx(target_velocity.y):
				return
	
	body.set_y_velocity(target_velocity.y)


func _get_target_velocity(delta: float) -> Vector3:
	var displacement = _target.position - body.position
	var leashed_distance = displacement.abs() - leash_distance
	
	if displacement.y <= 0:
		leashed_distance.y = absf(displacement.y) - negative_y_leash_distance
	
	leashed_distance.x = clampf(leashed_distance.x, 0.0, speed * delta)
	leashed_distance.y = clampf(leashed_distance.y, 0.0, speed * delta)
	leashed_distance.z = clampf(leashed_distance.z, 0.0, speed * delta)
	
	var leashed_displacement = displacement.sign() * leashed_distance
	var target_velocity = leashed_displacement / delta
	return target_velocity


func get_target() -> Node3D:
	return _target


func set_target(node: Node3D):
	_target = node

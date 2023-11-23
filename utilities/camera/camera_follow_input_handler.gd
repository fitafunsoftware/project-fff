class_name CameraFollowInputHandler
extends Node
## InputHandler for CameraFollowBody to control the body.
##
## Sets the target velocity for a body, usually a CameraFollowBody. Could be
## used for any body that wants to follow a target within a certain distance
## with no complex functionality.

## The body to control.
@export var body : Entity
## The target to follow.
@export var target : Node3D
## The speed at which the body should move at.
@export var speed : float = 3.0
## The max distance, in meters, the body can be from the target before moving
## the body.
@export var leash_distance : Vector3 = Vector3.ZERO
## The max negative y distance, in meters, the body can be from the target
## before moving the body.
@export var negative_y_leash_distance : float = 0.0


func _physics_process(delta):
	var target_velocity : Vector3 = _get_target_velocity(delta)
	
	var velocity_2d = Vector2(target_velocity.x, target_velocity.z)
	
	body.target_velocity_2d = velocity_2d
	
	if target is CharacterBody3D:
		# If the body is in the air but the target is on the floor, do not set
		# the body y velocity to 0. Let gravity make the body fall to the floor.
		if target.is_on_floor() and not body.is_on_floor():
			if is_zero_approx(target_velocity.y):
				return
	
	body.set_y_velocity(target_velocity.y)


# Gets the displacement between the body and the target, then leashes that
# displacement based on the leash distance.
func _get_target_velocity(delta: float) -> Vector3:
	var displacement = target.position - body.position
	var leashed_distance = displacement.abs() - leash_distance
	
	if displacement.y <= 0:
		leashed_distance.y = absf(displacement.y) - negative_y_leash_distance
	
	leashed_distance.x = clampf(leashed_distance.x, 0.0, body.speed * delta)
	leashed_distance.y = clampf(leashed_distance.y, 0.0, body.speed * delta)
	leashed_distance.z = clampf(leashed_distance.z, 0.0, body.speed * delta)
	
	var leashed_displacement = displacement.sign() * leashed_distance
	var target_velocity = leashed_displacement / delta
	return target_velocity

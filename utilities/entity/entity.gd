extends CharacterBody3D
class_name Entity

@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s")
var max_speed : float = 10.0 :
	get:
		return max_speed
	set(value):
		max_speed = value

@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s")
var friction : float = 4.0 :
	get:
		return friction
	set(value):
		friction = value

@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s")
var acceleration : float = 4.0 :
	get:
		return acceleration
	set(value):
		acceleration = value

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var target_velocity_2d := Vector2.ZERO :
	get:
		return target_velocity_2d
	set(value):
		target_velocity_2d = value

static var PIXEL_SIZE : float = NAN
static var FLOOR_GRADIENT : float = NAN


func  _init():
	floor_constant_speed = true
	platform_on_leave = CharacterBody3D.PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY


func _ready():
	if [PIXEL_SIZE, FLOOR_GRADIENT].has(NAN):
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_GRADIENT = GlobalParams.get_global_shader_param("FLOOR_GRADIENT")


func _physics_process(delta):
	velocity = _apply_gravity(velocity, delta)
	velocity = _apply_acceleration(velocity, target_velocity_2d, delta)
	velocity = _clamp_velocity(velocity)
	
	var _collided = move_and_slide()
	
	velocity = _zero_out_velocity(velocity)
	position = _snap_position(position)


func _apply_gravity(_velocity: Vector3, delta: float) -> Vector3:
	_velocity.y -= gravity * delta
	return _velocity


func _apply_acceleration(_velocity: Vector3, _target_velocity_2d: Vector2, delta: float) -> Vector3:
	var velocity_2d := Vector2(_velocity.x, _velocity.z)
	var final_acceleration := 0.0
	
	if target_velocity_2d == Vector2.ZERO:
		final_acceleration = friction
	else:
		if velocity_2d.is_equal_approx(Vector2.ZERO):
			final_acceleration = acceleration
		elif signf(target_velocity_2d.x) != signf(velocity_2d.x) \
				or signf(target_velocity_2d.y) != signf(velocity_2d.y):
			final_acceleration = friction + acceleration
		else:
			final_acceleration = acceleration
	
	var final_velocity_2d = velocity_2d.move_toward(target_velocity_2d, final_acceleration * delta)
	var final_y_velocity = _velocity.y
	
	var final_velocity = Vector3(final_velocity_2d.x, final_y_velocity, final_velocity_2d.y)
	return final_velocity


func _clamp_velocity(_velocity: Vector3) -> Vector3:
	_velocity.x = clampf(_velocity.x, -max_speed, max_speed)
	_velocity.y = clampf(_velocity.y, -max_speed, max_speed)
	_velocity.z = clampf(_velocity.z, -max_speed, max_speed)
	
	return _velocity

 
func _zero_out_velocity(_velocity: Vector3) -> Vector3:
	_velocity.x = 0.0 if is_zero_approx(_velocity.x) else _velocity.x
	_velocity.y = 0.0 if is_zero_approx(_velocity.y) else _velocity.y
	_velocity.z = 0.0 if is_zero_approx(_velocity.z) else _velocity.z
	
	return _velocity


func _snap_position(_position: Vector3) -> Vector3:
	var snapped_position := Vector3.ZERO
	snapped_position.x = snappedf(_position.x, PIXEL_SIZE)
	snapped_position.y = snappedf(_position.y, PIXEL_SIZE)
	snapped_position.z = snappedf(_position.z, PIXEL_SIZE/FLOOR_GRADIENT)
	return snapped_position


func get_y_velocity() -> float:
	return velocity.y


func set_y_velocity(y_velocity: float):
	velocity.y = y_velocity


func get_velocity_2d() -> Vector2:
	return Vector2(velocity.x, velocity.z)


func set_velocity_2d(velocity_2d: Vector2):
	velocity = Vector3(velocity_2d.x, velocity.y, velocity_2d.y)


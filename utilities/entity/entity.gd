class_name Entity
extends CharacterBody3D
## The base class for all entities in the game.
##
## Base class to implement basic functionality of entities in the game.

## The max speed of the entity.
@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s")
var max_speed: float = 10.0:
	get:
		return max_speed
	set(value):
		max_speed = value

## The friction applied to the entity when decelerating.
@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s²")
var friction: float = 4.0:
	get:
		return friction
	set(value):
		friction = value

## The acceleration of the entity to reach the target velocity.
@export_range(0.0, 100.0, 0.01, "hide_slider", "suffix:m/s²")
var acceleration: float = 4.0:
	get:
		return acceleration
	set(value):
		acceleration = value

## ID of this entity.
var entity_id: int = -1

# Set these values in global_params file.
## Multiplier to apply to gravity to get max gravity value.
static var APPLIED_GRAVITY_MULTIPLIER: float = NAN
## Y velocity value at which half of max gravity is applied.
static var HALFWAY_VELOCITY_POINT: float = NAN
# Growth rate constant for logistic gravity function.
static var _growth_rate: float = 0.0

## The base gravity applied on the entity.
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

## The x and z target velocity of the entity. Set this so acceleration and
## friction are applied.
var target_velocity_2d := Vector2.ZERO: get = get_target_velocity_2d, set = set_target_velocity_2d


func  _init():
	floor_constant_speed = true
	platform_on_leave = CharacterBody3D.PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY
	platform_floor_layers = 0


func _ready():
	_assign_global_params()
	global_position = GlobalParams.get_snapped_position(global_position)


func _physics_process(delta):
	velocity = _apply_gravity(velocity, delta)
	velocity = _apply_acceleration(velocity, target_velocity_2d, delta)
	velocity = _clamp_velocity(velocity)
	velocity = _zero_out_velocity(velocity)
	
	var _collided: bool = move_and_slide()
	
	global_position = GlobalParams.get_snapped_position(global_position)


## Return the y velocity of the entity.
func get_y_velocity() -> float:
	return velocity.y


## Set the y velocity of the entity.
func set_y_velocity(y_velocity: float):
	velocity.y = y_velocity


## Return the x and z velocity of the entity.
func get_velocity_2d() -> Vector2:
	return Vector2(velocity.x, velocity.z)


## Set the x and z velocity of the entity.
func set_velocity_2d(velocity_2d: Vector2):
	velocity = Vector3(velocity_2d.x, velocity.y, velocity_2d.y)


## Return the target x and z velocity of the entity.
func get_target_velocity_2d() -> Vector2:
	return target_velocity_2d


## Set the target x and z velocity of the entity.
func set_target_velocity_2d(value: Vector2):
	target_velocity_2d = value


# Helper functions.
func _assign_global_params():
	if [APPLIED_GRAVITY_MULTIPLIER, HALFWAY_VELOCITY_POINT].has(NAN):
		APPLIED_GRAVITY_MULTIPLIER = GlobalParams.get_global_param("APPLIED_GRAVITY_MULTIPLIER")
		HALFWAY_VELOCITY_POINT = GlobalParams.get_global_param("HALFWAY_VELOCITY_POINT")
		if APPLIED_GRAVITY_MULTIPLIER <= 2.0 or HALFWAY_VELOCITY_POINT <= 0.0:
			_growth_rate = 0.0
		else:
			_growth_rate = 2.0*log(APPLIED_GRAVITY_MULTIPLIER - 1.0)/HALFWAY_VELOCITY_POINT


# Calculate velocity after applying gravity.
func _apply_gravity(_velocity: Vector3, delta: float) -> Vector3:
	if is_on_floor() and _velocity.y < 0.0:
		_velocity.y = -0.01
	else:
		_velocity.y -= _get_applied_gravity(_velocity.y)*delta
	return _velocity


# Returns gravity applied to entity.
func _get_applied_gravity(y_velocity: float) -> float:
	if y_velocity >= 0.0:
		return gravity
	else:
		# Logistic function to scale gravity.
		return APPLIED_GRAVITY_MULTIPLIER*gravity/\
				(1.0 + exp(-_growth_rate*(abs(y_velocity) - HALFWAY_VELOCITY_POINT/2.0)))


# Calculate velocity after applying acceleration to reach target velocity.
func _apply_acceleration(_velocity: Vector3, _target_velocity_2d: Vector2, delta: float) -> Vector3:
	var velocity_2d := Vector2(_velocity.x, _velocity.z)
	var final_acceleration := 0.0
	
	if target_velocity_2d.is_equal_approx(Vector2.ZERO):
		final_acceleration = friction
	else:
		if velocity_2d.is_equal_approx(Vector2.ZERO):
			final_acceleration = acceleration
		elif is_equal_approx(signf(target_velocity_2d.x), -signf(velocity_2d.x)) \
				or is_equal_approx(signf(target_velocity_2d.y), -signf(velocity_2d.y)):
			final_acceleration = friction + acceleration
		else:
			final_acceleration = acceleration
	
	var final_velocity_2d: Vector2 = velocity_2d.move_toward(target_velocity_2d, final_acceleration * delta)
	var final_y_velocity: float = _velocity.y
	
	var final_velocity := Vector3(final_velocity_2d.x, final_y_velocity, final_velocity_2d.y)
	return final_velocity


# Calculate the velocity clamped to the max speed of the entity.
func _clamp_velocity(_velocity: Vector3) -> Vector3:
	_velocity.x = clampf(_velocity.x, -max_speed, max_speed)
	_velocity.y = clampf(_velocity.y, -max_speed, max_speed)
	_velocity.z = clampf(_velocity.z, -max_speed, max_speed)
	
	return _velocity

 
# Zero out any values of the velocity that is close enough.
func _zero_out_velocity(_velocity: Vector3) -> Vector3:
	_velocity.x = 0.0 if is_zero_approx(_velocity.x) else _velocity.x
	_velocity.y = 0.0 if is_zero_approx(_velocity.y) else _velocity.y
	_velocity.z = 0.0 if is_zero_approx(_velocity.z) else _velocity.z
	
	return _velocity

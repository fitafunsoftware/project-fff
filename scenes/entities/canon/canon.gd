class_name ProjectileSpawner
extends Node3D

const ANGLE := deg_to_rad(45.0)
const POWER := 7.0

@export var SHOOT_DELAY := 4.0

var _projectile_path: String = "uid://c1tph2qgbx88w"
var _projectile: PackedScene = preload("uid://c1tph2qgbx88w")
var _entity_spawn_request: EntitySpawnRequest


func _ready():
	ResourceQueue.queue_resource(_projectile_path)
	_generate_entity_spawn_request()
	_shoot_projectile.call_deferred()


func _generate_entity_spawn_request():
	var dummy: Entity = _projectile.instantiate()
	
	var set_global_position_callable = dummy.set.bind("global_position", global_position)
	var projectile_velocity: Vector2 = Vector2.RIGHT.rotated(ANGLE)*POWER
	var projectile_velocity_2d := Vector2(projectile_velocity.x, 0.0)	
	var set_target_velocity_2d_callable := dummy.set_target_velocity_2d.bind(projectile_velocity_2d)
	var set_velocity_2d_callable := dummy.set_velocity_2d.bind(projectile_velocity_2d)
	var set_y_velocity_callable := dummy.set_y_velocity.bind(projectile_velocity.y)
	var post_add_callables: Array[Callable] = [set_global_position_callable,
			set_target_velocity_2d_callable, set_velocity_2d_callable, set_y_velocity_callable]
	var post_add_functions: Array[EntityFunctionCall] = \
			EntityFunctionCall.create_array_from_callables(post_add_callables)
	
	_entity_spawn_request = EntitySpawnRequest.new(_projectile_path, [],
			post_add_functions)


func _shoot_projectile():
	GlobalEntitySpawner.spawn_entity(self, _entity_spawn_request)
	await get_tree().create_timer(SHOOT_DELAY).timeout
	_shoot_projectile.call_deferred()

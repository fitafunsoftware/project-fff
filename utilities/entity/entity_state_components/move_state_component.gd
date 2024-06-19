@tool
@icon("move_state_component.png")
extends EntityStateComponent
class_name MoveStateComponent
## State component for entitiy movement.
##
## A basic state component that just turns input from an InputHandler into 
## target movement on an Entity.

## Key for the Entity node in dependencies.
@export var entity_key : StringName = &"entity_key"
## Key for the InputHandler node in dependencies.
@export var input_key : StringName = &"input_key"
## Key for the speed float in dependencies.
@export var speed_key : StringName = &"speed_key"

var entity : Entity :
	get:
		return dependencies.get(entity_key)

var input : InputHandler :
	get:
		return dependencies.get(input_key)

var speed : float :
	get:
		return dependencies.get(speed_key, 0.0)


func update(_delta: float):
	var input_direction : Vector2 = input.get_input_direction()
	entity.target_velocity_2d = input_direction * speed


func get_dependencies() -> Array[StringName]:
	var array : Array[StringName] = super()
	array.append_array([entity_key, input_key, speed_key])
	return array

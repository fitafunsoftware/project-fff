@icon("res://addons/state_machine/icons/state.png")
extends Node
class_name State

signal change_state(requestor, next_state)

@export var state_name : String = "state_name":
	set(value):
		if value == "previous":
			state_name = "previous_not_allowed_as_name"
		else:
			state_name = value
@export var push_down : bool = false
@export var overwrite : bool = false


func enter():
	pass


func resume():
	pass


func exit():
	pass


func handle_input(_event: InputEvent):
	pass


func update(_delta: float):
	pass


func on_animation_finished(_animation: String):
	pass


func finished(next_state: String):
	change_state.emit(state_name, next_state)

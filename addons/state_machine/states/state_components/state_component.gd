@tool
@icon("res://addons/state_machine/icons/state_components/state_component.png")
extends Resource
class_name StateComponent

signal dependencies_changed

@export var active := true : set = _set_active

var state : State
var dependencies : Dictionary


func ready():
	pass


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


func get_dependencies() -> Array[String]:
	var array : Array[String]
	array.assign(Array())
	return array


func _set_active(value: bool):
	active = value

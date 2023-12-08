@tool
extends NestingStateComponent
class_name ActivationStateComponent

const FORCE = true

@export var activate : bool = true

var _is_active : Array[bool]
var _activated : bool


func ready():
	super()
	_populate_is_active()
	set_activated(not activate, FORCE)


func _populate_is_active():
	_is_active.assign(Array())
	for component in components:
		_is_active.append(component.active)


func set_activated(value: bool, force: bool = false):
	if not force:
		if _activated == value:
			return
	
	_activated = value
	_activate_components(_activated)


func _activate_components(value: bool):
	for index in components.size():
		components[index].active = _is_active[index] if value else false


func _set_active(value: bool):
	_activate_components(value)
	active = value

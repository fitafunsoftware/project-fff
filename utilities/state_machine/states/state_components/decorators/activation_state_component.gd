@tool
extends NestingStateComponent
class_name ActivationStateComponent
## A NestingStateComponent that activates or deactivates its descendent StateComponents.

const FORCE = true

## If true, activates when active, deactivate when deactivated.[br]
## If false, activates when deactivated, deactivates when activated.
@export var activate : bool = true

var _is_active : Array[bool]
var _activated : bool


func ready():
	super()
	_populate_is_active()
	set_activated(not activate, FORCE)


func _populate_is_active():
	_is_active.assign(Array())
	for component in _components:
		_is_active.append(component.active)


## Function to activate all descendent components.
func set_activated(value: bool, force: bool = false):
	if Engine.is_editor_hint():
		return
	
	if not force:
		if _activated == value:
			return
	
	_activated = value
	_activate_components(_activated)


func _activate_components(value: bool):
	for index in _components.size():
		_components[index].active = _is_active[index] if value else false


func _set_active(value: bool):
	_activate_components(value)
	active = value

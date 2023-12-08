@tool
@icon("res://addons/state_machine/icons/state_components/delayed.png")
extends ActivationStateComponent
class_name DelayedActivationStateComponent


@export var delay: float = 0.0

var _timer : SceneTreeTimer = null

func enter():
	_start_timer()
	super()


func resume():
	_start_timer()
	super()


func exit():
	if not _timer:
		return
	
	for connection in _timer.timeout.get_connections():
		connection["signal"].disconnect(connection["callable"])
	
	super()


func _start_timer():
	set_activated(not activate)
	_timer = state.get_tree().create_timer(delay)
	_timer.timeout.connect(set_activated.bind(activate))
	_timer.timeout.connect(_nullify_timer)


func _nullify_timer():
	_timer = null

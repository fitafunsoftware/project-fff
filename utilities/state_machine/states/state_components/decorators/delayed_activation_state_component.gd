@tool
@icon("delayed.png")
extends ActivationStateComponent
class_name DelayedActivationStateComponent
## StateComponents that activates or deactivates descendents after a delay.

## Delay before activating or deactivating descendants.
@export var delay: float = 0.0

var _timer : SceneTreeTimer = null

func enter():
	_start_timer()


func resume():
	_start_timer()


func exit():
	if not _timer:
		return
	
	for connection in _timer.timeout.get_connections():
		connection["signal"].disconnect(connection["callable"])


func _start_timer():
	set_activated(not activate)
	_timer = get_tree().create_timer(delay)
	_timer.timeout.connect(set_activated.bind(activate))
	_timer.timeout.connect(_nullify_timer)


func _nullify_timer():
	_timer = null

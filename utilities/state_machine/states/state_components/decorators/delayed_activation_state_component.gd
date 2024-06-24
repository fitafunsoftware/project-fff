@tool
@icon("delayed.png")
extends ActivationStateComponent
class_name DelayedActivationStateComponent
## StateComponents that activates or deactivates descendents after a delay.

## Delay before activating or deactivating descendants.
@export var delay: float = 0.0 :
	set(value):
		if value >= 0.0:
			delay = value

var _timer : SceneTreeTimer = null


func enter():
	_start_timer(delay)


func resume():
	_start_timer(delay)


func exit():
	_disconnect_timer()


func seek(seconds: float):
	if seconds <= 0.0:
		return
	
	_disconnect_timer()
	if seconds >= delay:
		set_activated(activate)
		_nullify_timer()
	else:
		_start_timer(delay - seconds)


func _start_timer(time_sec: float):
	set_activated(not activate)
	_timer = get_tree().create_timer(time_sec)
	_timer.timeout.connect(set_activated.bind(activate))
	_timer.timeout.connect(_nullify_timer)


func _nullify_timer():
	_timer = null


func _disconnect_timer():
	if not _timer:
		return
	
	for connection : Dictionary in _timer.timeout.get_connections():
		connection["signal"].disconnect(connection["callable"])

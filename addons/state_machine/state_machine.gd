@icon("res://addons/state_machine/icons/state_machine.png")
extends Node
class_name StateMachine

signal state_changed(current_state)
signal states_stack_changed(states_stack)

@export var active : bool = false :
	set(value):
		if active == value:
			return
		
		active = value
		set_physics_process(active)
		_initialize() if active else _clean_up()
@export var start_state : String

var current_state : State = null
var _states_map : Dictionary = {}

var _states_stack : Array[State] = []
var _push_down_states : PackedStringArray = []
var _overwrite_states : PackedStringArray = []


func _ready():
	_populate_states_map()
	_initialize()


func _physics_process(delta):
	current_state.update(delta)


func handle_input(event: InputEvent):
	current_state.handle_input(event)


func _populate_states_map():
	for state in get_children():
		if state is State:
			_states_map[state.state_name] = state
			state.change_state.connect(change_state)


func _initialize():
	if _states_map.is_empty():
		return
	
	if _states_map.has(start_state):
		_states_stack[0] = _states_map[start_state]
	else:
		_states_stack[0] = _states_map.values()[0]
	current_state = _states_stack.front()
	current_state.enter()


func _clean_up():
	current_state.exit()
	_states_stack.clear()
	current_state = null


func change_state(requestor: String, next_state: String):
	if not active:
		return
	
	if current_state.state_name != requestor:
		return
	
	var next_is_previous : bool = next_state == "previous"
	if not next_is_previous:
		if not _states_map.has(next_state):
			return
	
	if next_state in _overwrite_states:
		if _states_stack.size() > 1:
			_states_stack.pop_front()
	
	current_state.exit()
	
	if next_state in _push_down_states:
		_states_stack.push_front(_states_map[next_state])
	elif next_is_previous:
		_states_stack.pop_front()
	else:
		_states_stack.clear()
		_states_stack[0] = _states_map[next_state]
	
	current_state = _states_stack.front()
	state_changed.emit(current_state.state_name)
	states_stack_changed.emit(_states_stack)
	
	current_state.resume() if next_is_previous else current_state.enter()


func _on_animation_finished(animation: String):
	current_state.on_animation_finished(animation)

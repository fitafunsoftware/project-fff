@icon("state_machine.png")
class_name StateMachine
extends Node
## Basic State Machine node.
##
## A State Machine component that can honestly be used by anything. Features
## push down states and overwrites states.

## Signal emitted when the state changes.
signal state_changed(current_state: StringName)
## Signal emitted when the states stack changes.
signal states_stack_changed(states_stack: Array[StringName])

## The StringName used to check if the previous state is requested to be the
## next state.
const PREVIOUS: StringName = &"previous"

## Is the StateMachine active?
@export var active: bool = false:
	set(value):
		if active == value:
			return
		active = value
		set_physics_process(active)
		if active:
			_initialize()
		else:
			_clean_up()
## State to start the StateMachine on. Defaults to the first state, which
## might be random, if not set.
@export var start_state: StringName

## The current state of the StateMachine.
var _current_state: State = null
var _states_stack: Array[State]

var _states_map: Dictionary[StringName, State]
var _push_down_states: PackedStringArray = []
var _overwrite_states: PackedStringArray = []


func _ready():
	_populate_states_map()
	_initialize()


func _physics_process(delta):
	_current_state.update(delta)


## Function to pass InputEvents to the current state.[br]Note that this function
## is different from any of the virtual input functions, but it still takes the
## same arguments.
func handle_input(event: InputEvent):
	_current_state.handle_input(event)


## Configure the state machine with the given [param states_stack]. The last 
## element will be the [param current_state]. The [param seconds] parameter
## informs the new [param current_state] what time to seek to.
func configure_state_machine(states_stack: Array[StringName], seconds: float = 0.0):
	if not active:
		return
	
	if seconds < 0.0:
		seconds = 0.0
	
	_states_stack.assign(
		states_stack.map(func(state: StringName): return _states_map[state])
	)
	_current_state = _states_stack.back()
	_current_state.enter()
	_current_state.seek(seconds)
	
	_emit_all_signals()


## Get the name of the current state. Returns an empty StringName if there is
## no current state.
func get_current_state() -> StringName:
	return _current_state.state_name if _current_state else StringName()


## Returns an array with the names of the states in the states stack. Top of the
## stack is the back or last element, and bottom is the front or first element.
func get_states_stack() -> Array[StringName]:
	var states_stack: Array[StringName]
	states_stack.assign(
		_states_stack.map(func(state: State): return state.state_name)
	)
	return states_stack


## Functions to change the state of the StateMachine.[br]Ignores the request if
## the requestor is not the same as the current state or if the next_state is not
## in the StateMachine.[br]The StringName in PREVIOUS is used to call for the
## previous states on the stack. Meant to be called by the States.
func change_state(requestor: StringName, next_state: StringName):
	if not active:
		return
	
	if _current_state.state_name != requestor:
		return
	
	var next_is_previous: bool = next_state == PREVIOUS
	if not next_is_previous:
		if not _states_map.has(next_state):
			return
	
	if next_state in _overwrite_states:
		if _states_stack.size() > 1:
			_states_stack.pop_back()
	
	_current_state.exit()
	
	if next_state in _push_down_states:
		_states_stack.push_back(_states_map[next_state])
	elif next_is_previous:
		_states_stack.pop_back()
	else:
		_states_stack.clear()
		_states_stack.push_back(_states_map[next_state])
	
	_current_state = _states_stack.back()
	if next_is_previous:
		_current_state.resume() 
	else:
		_current_state.enter()
	
	_emit_all_signals()


# Private helper functions.
func _populate_states_map():
	for state: Node in get_children():
		if state is State:
			var state_name: StringName = state.state_name
			_states_map[state_name] = state
			state.change_state.connect(change_state)
			if state.push_down:
				_push_down_states.append(state_name)
			if state.overwrite:
				_overwrite_states.append(state_name)


func _initialize():
	if _states_map.is_empty():
		return
	
	if _states_map.has(start_state):
		_states_stack.push_back(_states_map[start_state])
	else:
		_states_stack.push_back(_states_map.values()[0])
	_current_state = _states_stack.back()
	_current_state.enter()
	
	_emit_all_signals()


func _clean_up():
	_current_state.exit()
	_states_stack.clear()
	_current_state = null
	
	_emit_all_signals()


func _emit_all_signals():
	state_changed.emit(get_current_state())
	states_stack_changed.emit(get_states_stack())


# Signal callbacks.
func _on_animation_finished(animation: StringName):
	_current_state.on_animation_finished(animation)

@tool
@icon("res://addons/state_machine/icons/state_components/animation_finished.png")
extends StateComponent
class_name AnimationFinishedStateComponent

@export var animation : String
@export var next_state : String


func on_animation_finished(finished_animation: String):
	if finished_animation == animation:
		state.finished(next_state)

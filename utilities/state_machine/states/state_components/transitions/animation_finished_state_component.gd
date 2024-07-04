@tool
@icon("animation_finished.png")
class_name AnimationFinishedStateComponent
extends StateComponent
## StateComponent that calls for a state change when an animation is finished.

@export var animation : StringName
@export var next_state : StringName


func on_animation_finished(finished_animation: StringName):
	if finished_animation == animation:
		finished.call(next_state)

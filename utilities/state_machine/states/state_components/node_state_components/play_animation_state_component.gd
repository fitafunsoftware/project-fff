@tool
@icon("uid://c7xbutsv8mo24")
class_name PlayAnimationStateComponent
extends StateComponent
## StateComponent for playing animations on enter and resume.
##
## StateComponent will play the given animation on enter and on resume. Also
## has seek integrated into it so animations can bet set to a specific time.

## Key for AnimationPlayer.
@export var animation_player_key: StringName = &"animation_player"
## The name of the animation to be played.
@export var animation: StringName = &"animation"

var animation_player: AnimationPlayer:
	get:
		return dependencies.get(animation_player_key) 


func enter():
	animation_player.play(animation)


func resume():
	animation_player.play(animation)


func seek(seconds: float):
	animation_player.advance(seconds)


func get_dependencies() -> Array[StringName]:
	var array: Array[StringName] = super()
	array.append(animation_player_key)
	return array

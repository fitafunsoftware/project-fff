class_name ResetToScene
extends Node
## Helper node for changing scenes with a combo action.
##
## Node to help give a scene the ability to change to a scene when the given Input action 
## combination is pressed. The reset_scene can be set to the same scene as the current one
## to act as a scene reset.

## Scene to change to on combo press.
@export_file("*.tscn") var reset_scene: String
## Does the reset_scene use the virtual touch controls?
@export var touch_controls: bool = false
## The combination of Input actions needed to be pressed to change scenes.
@export var reset_combo: Array[StringName]


func _unhandled_input(event: InputEvent):
	if _reset_to_scene(event):
		_reset()


func _reset_to_scene(event: InputEvent) -> bool:
	if event.is_pressed():
		for action: StringName in reset_combo:
			if event.is_action(action):
				return InputHelper.is_action_combo_pressed(reset_combo)
	
	return false


func _reset():
	get_viewport().change_scene.call_deferred(reset_scene, touch_controls)

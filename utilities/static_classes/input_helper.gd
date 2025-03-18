class_name InputHelper
extends Object
## Static helper class for parsing input.
##
## A static class meant to house functions that help with parsing input.


## Returns whether a given combination of Input actions are currently pressed.
static func is_action_combo_pressed(action_combo: Array[StringName]) -> bool:
	for action: StringName in action_combo:
		if not Input.is_action_pressed(action):
			return false
	
	return true

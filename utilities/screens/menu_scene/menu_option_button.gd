extends Button
## Button for changing scenes.
##
## Change to the next scene when the button is pressed. Use loading scene if
## told to.

## The next scene to load when pressed.
var next_scene : String
## Use loading scene before loading the next scene.
var loading_scene : bool
## Enable touch controls in next scene.
var touch_controls : bool = false


func _ready():
	if not loading_scene:
		get_viewport().queue_scene(next_scene)
	pressed.connect(_change_scene)


## Set up the values of the button.
func setup_button(option : String, scene : String, loading : bool, touch : bool):
	text = option
	next_scene = scene
	loading_scene = loading
	touch_controls = touch


# Change scene when the button is pressed.
func _change_scene():
	if loading_scene:
		get_viewport().change_to_loading_scene(next_scene, touch_controls)
	else:
		get_viewport().change_scene(next_scene, touch_controls)

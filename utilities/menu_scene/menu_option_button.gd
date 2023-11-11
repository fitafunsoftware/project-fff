extends Button

var next_scene : String
var loading_scene : bool


func _ready():
	get_viewport().queue_scene(next_scene)
	pressed.connect(_change_scene)


func setup_button(option : String, scene : String, loading : bool):
	text = option
	next_scene = scene
	loading_scene = loading


func _change_scene():
	if loading_scene:
		get_viewport().change_to_loading_scene(next_scene)
	else:
		get_viewport().change_scene(next_scene)

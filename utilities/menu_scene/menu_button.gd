extends Button

var next_scene : String


func setup_button(option : String, scene : String):
	text = option
	next_scene = scene
	get_viewport().queue_scene(scene)
	pressed.connect(_change_scene)


func _change_scene():
	get_viewport().change_scene(next_scene)

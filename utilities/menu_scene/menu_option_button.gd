extends Button

var next_scene : String


func _ready():
	get_viewport().queue_scene(next_scene)
	pressed.connect(_change_scene)


func setup_button(option : String, scene : String):
	text = option
	next_scene = scene


func _change_scene():
	get_viewport().change_scene(next_scene)

extends SubViewportContainer

const BASE_SIZE := Vector2i(640, 360)

@export_file("*.tscn") var start_scene : String

@onready var window : Window = get_tree().get_root()


func _ready():
	_on_window_resized()
	window.size_changed.connect(_on_window_resized)
	
	$GameViewport.change_scene(start_scene)


func _on_window_resized():
	var window_scale : Vector2i = window.size/BASE_SIZE
	var new_scale : int = int(min(window_scale.x, window_scale.y))
	
	set_size(BASE_SIZE*new_scale)
	stretch_shrink = new_scale
	set_offsets_preset(Control.PRESET_CENTER,Control.PRESET_MODE_KEEP_SIZE)

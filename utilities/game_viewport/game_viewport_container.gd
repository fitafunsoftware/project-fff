extends SubViewportContainer

static var BASE_SIZE_X : float = NAN
static var BASE_SIZE_Y : float = NAN
static var MAX_BASE_SIZE_X : float = NAN
static var MAX_BASE_SIZE_Y : float = NAN

@onready var window : Window = get_tree().get_root()


func _ready():
	_on_window_resized()
	window.size_changed.connect(_on_window_resized)


func start_scene(starting_scene: String):
	$GameViewport.change_scene(starting_scene)


func _on_window_resized():
	if [BASE_SIZE_X, BASE_SIZE_Y, MAX_BASE_SIZE_X, MAX_BASE_SIZE_Y].has(NAN):
		BASE_SIZE_X = GlobalParams.get_global_param("BASE_SIZE_X")
		BASE_SIZE_Y = GlobalParams.get_global_param("BASE_SIZE_Y")
		MAX_BASE_SIZE_X = GlobalParams.get_global_param("MAX_BASE_SIZE_X")
		MAX_BASE_SIZE_Y = GlobalParams.get_global_param("MAX_BASE_SIZE_Y")
	
	@warning_ignore("narrowing_conversion")
	var window_scale : Vector2i = window.size/Vector2i(BASE_SIZE_X, BASE_SIZE_Y)
	var new_scale : int = mini(window_scale.x, window_scale.y)
	var new_unscaled_size : Vector2i = window.size/new_scale
	@warning_ignore("narrowing_conversion")
	var new_base_size : Vector2i = Vector2i(
			mini(MAX_BASE_SIZE_X, new_unscaled_size.x),
			mini(MAX_BASE_SIZE_Y, new_unscaled_size.y))
	
	set_size(new_base_size*new_scale)
	stretch_shrink = new_scale
	set_offsets_preset(Control.PRESET_CENTER,Control.PRESET_MODE_KEEP_SIZE)

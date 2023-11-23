extends SubViewportContainer
## SubViewportContainer for the GameViewport
##
## Handles the resizing of the GameViewport based on global parameters set in
## the [code]global_params.json[/code]. The GameViewport will always be an
## integer scale of the base size. The base size can vary to accomodate for
## different aspect ratios.

## Base width of the game viewport.
static var BASE_SIZE_X : float = NAN
## Base height of the game viewport.
static var BASE_SIZE_Y : float = NAN
## Max base width of the game viewport.
static var MAX_BASE_SIZE_X : float = NAN
## Max base height of the game viewport.
static var MAX_BASE_SIZE_Y : float = NAN


@onready var _window : Window = get_tree().get_root()


func _ready():
	_on_window_resized()
	_window.size_changed.connect(_on_window_resized)


## Change to the given starting_scene.
func start_scene(starting_scene: String):
	$GameViewport.change_scene(starting_scene)


# Window resize logic to resize the viewport and calculate the proper scaling
# factor.
func _on_window_resized():
	if [BASE_SIZE_X, BASE_SIZE_Y, MAX_BASE_SIZE_X, MAX_BASE_SIZE_Y].has(NAN):
		BASE_SIZE_X = GlobalParams.get_global_param("BASE_SIZE_X")
		BASE_SIZE_Y = GlobalParams.get_global_param("BASE_SIZE_Y")
		MAX_BASE_SIZE_X = GlobalParams.get_global_param("MAX_BASE_SIZE_X")
		MAX_BASE_SIZE_Y = GlobalParams.get_global_param("MAX_BASE_SIZE_Y")
	
	@warning_ignore("narrowing_conversion")
	var _window_scale : Vector2i = _window.size/Vector2i(BASE_SIZE_X, BASE_SIZE_Y)
	var new_scale : int = mini(_window_scale.x, _window_scale.y)
	var new_unscaled_size : Vector2i = _window.size/new_scale
	@warning_ignore("narrowing_conversion")
	var new_base_size : Vector2i = Vector2i(
			mini(MAX_BASE_SIZE_X, new_unscaled_size.x),
			mini(MAX_BASE_SIZE_Y, new_unscaled_size.y))
	
	set_size(new_base_size*new_scale)
	stretch_shrink = new_scale
	set_offsets_preset(Control.PRESET_CENTER,Control.PRESET_MODE_KEEP_SIZE)

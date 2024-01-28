extends SubViewportContainer
## SubViewportContainer for the GameViewport
##
## Handles the resizing of the GameViewport based on global parameters set in
## the [code]global_params.json[/code]. The GameViewport will always be an
## integer scale of the base size. The base size can vary to accomodate for
## different aspect ratios. [br] 
## Accommodated aspect ratios: Auto, 16:9, 16:10, 3:2, 4:3. These correspond to
## Auto, HD, Laptop, GBA, and SD aspect ratios. Auto tries to maintain 16:9 in
## windowed mode, but fills up the screen up to 4:3 in fullscreen mode.

## Minimum size for corresponding aspect ratios.
const MIN_SIZE = [
	Vector2i(640, 360), ## Auto, emulates 16:9
	Vector2i(640, 360), ## 16:9
	Vector2i(640, 400), ## 16:10
	Vector2i(642, 428), ## 3:2
	Vector2i(640, 480), ## 4:3
]

## Maximum size for corresponding aspect ratios.
const MAX_SIZE = [
	Vector2i(666, 480), ## Auto, emulates 4:3
	Vector2i(656, 369), ## 16:9
	Vector2i(656, 410), ## 16:10
	Vector2i(666, 444), ## 3:2
	Vector2i(666, 480), ## 4:3
]


# Attach signals and resize window to start.
func _ready():
	resize_window()
	GlobalSettings.window_properties_changed.connect(resize_window)
	GlobalSettings.aspect_ratio_changed.connect(_on_aspect_ratio_changed)
	GlobalSettings.scaling_changed.connect(_on_scaling_changed)


## Change to the given starting_scene.
func start_scene(starting_scene: String):
	$GameViewport.change_scene(starting_scene)


## Resize window using the saved settings in the GlobalSettings autoload.
func resize_window():
	_resize_viewport_and_window(GlobalSettings.aspect_ratio, GlobalSettings.scaling)


func _on_aspect_ratio_changed(aspect_ratio: int):
	_resize_viewport_and_window(aspect_ratio, GlobalSettings.scaling)


func _on_scaling_changed(scaling: int):
	_resize_viewport_and_window(GlobalSettings.aspect_ratio, scaling)


# Resize logic to resize the viewport and calculate the proper scaling
# factor. Window resizing gets passed off to the GlobalSettings autoload.
func _resize_viewport_and_window(aspect_ratio: int, scaling: int):
	var min_size : Vector2i = MIN_SIZE[aspect_ratio]
	var screen_size : Vector2i = GlobalSettings.get_screen_size()
	var screen_scale : Vector2i = screen_size/min_size
	
	var new_scale : int = maxi(mini(screen_scale.x, screen_scale.y), 1)
	new_scale = mini(new_scale, scaling)
	
	var new_unscaled_size : Vector2i = screen_size/new_scale
	var max_size : Vector2i = \
			MAX_SIZE[aspect_ratio] if GlobalSettings.fullscreen \
			else min_size
	var new_base_size : Vector2i = Vector2i(
			maxi(mini(max_size.x, new_unscaled_size.x), min_size.x),
			maxi(mini(max_size.y, new_unscaled_size.y), min_size.y))
	
	set_size(new_base_size*new_scale)
	stretch_shrink = new_scale
	set_offsets_preset(Control.PRESET_CENTER,Control.PRESET_MODE_KEEP_SIZE)
	
	GlobalSettings.set_window_size(size)

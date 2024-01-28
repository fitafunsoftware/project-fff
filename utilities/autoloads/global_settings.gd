extends Node
## GlobalSettings Autoload to handle global settings.
##
## Handles the storage of settings and emitting signals when settings change.
## Currently saves settings to a JSON. This is to allow users to change the file
## to change the settings as well.

signal aspect_ratio_changed(aspect_ratio)
signal scaling_changed(scaling)
signal window_properties_changed()

## Save file for the settings.
const SETTINGS_JSON : String = "user://settings.json"

## The aspect ratios accommodated for.
enum AspectRatio {AUTO, HD, LAPTOP, GBA, SD}

## Minimum size for each aspect ratio.
const MIN_SIZE = [
	Vector2i(640, 360), ## Auto 16:9
	Vector2i(640, 360), ## HD 16:9
	Vector2i(640, 400), ## Laptop 16:10
	Vector2i(640, 428), ## GBA 3:2
	Vector2i(640, 480), ## SD 4:3
]

## Minimum FPS Limit value if not uncapped.
const MIN_FPS_LIMIT = 30

## Aspect ratio to abide by.
var aspect_ratio : AspectRatio = AspectRatio.AUTO :
	set(value):
		aspect_ratio = value
		aspect_ratio_changed.emit(aspect_ratio)

## Scaling for the resolution. [br]Only integer scaling is allowed. Clamps to the
## maximum size allowed by the display.
var scaling : int = 10 :
	set(value):
		var max_scale : int = _get_max_scale()
		scaling = clampi(value, 1, max_scale)
		scaling_changed.emit(scaling)

## Window Fullsceen.
var fullscreen : bool = true:
	set(value):
		fullscreen = value
		_set_window_properties()

## Borderless. Determines Exclusive Fullscreen when in fullscreen mode.
var borderless : bool = true :
	set(value):
		borderless = value
		_set_window_properties()

## V-Sync.
var vsync : bool = true :
	set(value):
		vsync = value
		_set_vsync()

## FPS Limit. Lower limit is MIN_FPS_LIMIT fps, with 0 being uncapped.
var fps_limit : int = 0 :
	set(value):
		fps_limit = clampi(value, 0, 10_000)
		_set_fps_limit()

@onready var _window : Window = get_window()
@onready var _override_saveable : bool = _is_override_saveable()


func _ready():
	_load_settings_from_file()


# Save settings on quit.
func _notification(what):
	if what in [NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_WM_GO_BACK_REQUEST]:
		save_settings()


## Returns an array of allowable aspect ratios at the given scale.
func get_allowed_aspect_ratios(at_scale: int = 1) -> Array:
	var allowed_aspect_ratios = Array()
	var screen_size : Vector2i = get_screen_size()
	
	for index in AspectRatio.size():
		var screen_scale : Vector2i = screen_size/MIN_SIZE[index]
		var max_size : int = mini(screen_scale.x, screen_scale.y)
		
		if max_size >= at_scale:
			allowed_aspect_ratios.append(index)
	
	return allowed_aspect_ratios


## Returns an array of allowable scaling factors.
func get_allowed_scalings() -> Array:
	var max_scale : int = _get_max_scale()
	var allowed_scalings : Array = range(1, max_scale + 1)
	return allowed_scalings


## Return the screen size available to be used. Influenced by fullscreen and 
## borderless settings.
func get_screen_size() -> Vector2i:
	var screen : int = _window.current_screen
	var screen_size : Vector2i
	
	if fullscreen or borderless:
		screen_size = DisplayServer.screen_get_size(screen)
	else:
		screen_size = DisplayServer.screen_get_usable_rect(screen).size
	
	return screen_size


## Set the window to the requested size. Ignored if in fullscreen mode.
func set_window_size(size: Vector2i):
	if fullscreen:
		return
	if _window.size == size:
		return
	
	_window.size = size
	_window.move_to_center()


## Save settings to a JSON and save override if possible.
func save_settings():
	_save_settings_to_json()
	_save_project_settings()


# Private helper functions

func _get_max_scale() -> int:
	var window_scale : Vector2i = get_screen_size()/MIN_SIZE[aspect_ratio]
	return mini(window_scale.x, window_scale.y)


func _load_settings_from_file():
	var options : Dictionary = Dictionary()
	if FileAccess.file_exists(SETTINGS_JSON):
		options = JSON.parse_string(FileAccess.get_file_as_string(SETTINGS_JSON))
	
	aspect_ratio = _get_from_options(options, "aspect_ratio", aspect_ratio)
	fullscreen = _get_from_options(options, "fullscreen", fullscreen)
	scaling = _get_from_options(options, "scaling", scaling)
	borderless = _get_from_options(options, "borderless", borderless)
	vsync = _get_from_options(options, "vsync", vsync)
	fps_limit = _get_from_options(options, "fps_limit", fps_limit)


# Helper function in case I need to change the behavior for setting all the 
# vars from the Dictionary.
func _get_from_options(options: Dictionary, key: String, default: Variant) -> Variant:
	var value = options.get(key)
	if typeof(value) == typeof(default):
		return value
	
	return default


func _apply_settings():
	_set_borderless()
	_set_window_properties()
	_set_vsync()
	_set_fps_limit()
	
	aspect_ratio_changed.emit(aspect_ratio)
	scaling_changed.emit(scaling)


func _set_window_properties():
	_set_borderless()
	_set_window_mode()
	window_properties_changed.emit()


func _set_window_mode():
	var new_mode
	
	if fullscreen:
		if borderless:
			new_mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			new_mode = Window.MODE_FULLSCREEN
	else:
		new_mode = Window.MODE_WINDOWED
	
	_window.mode = new_mode


func _set_borderless():
	_window.borderless = borderless


func _set_vsync():
	var vsync_mode = DisplayServer.VSYNC_ENABLED if vsync \
			else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)


func _set_fps_limit():
	var max_fps : int = fps_limit
	
	if fps_limit <= 0:
		max_fps = 0
	elif fps_limit <= MIN_FPS_LIMIT:
		max_fps = MIN_FPS_LIMIT
	 
	Engine.max_fps = max_fps


# Check to see if you can save an override file for Project Settings.
func _is_override_saveable() -> bool:
	var file = FileAccess.open("res://override.cfg", FileAccess.WRITE)
	if file:
		file.close()
		return true
	 
	return false


func _save_settings_to_json():
	var settings_dict : Dictionary = {
		"aspect_ratio_list" : "0: Auto, 1: 16:9, 2: 16:10, 3: 3:2, 4: 4:3",
		"aspect_ratio" : aspect_ratio,
		"fullscreen" : fullscreen,
		"scaling" : scaling,
		"borderless" : borderless,
		"vsync" : vsync,
		"fps_limit" : fps_limit,
	}
	
	var settings_json : String = JSON.stringify(settings_dict, "\t")
	var file : FileAccess = FileAccess.open(SETTINGS_JSON, FileAccess.WRITE)
	file.store_string(settings_json)
	file.close()


func _save_project_settings():
	if not _override_saveable:
		return
	
	ProjectSettings.set_setting("display/window/size/initial_screen",
			_window.current_screen)
	ProjectSettings.set_setting("display/window/size/mode", _window.mode)
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", 
			DisplayServer.window_get_vsync_mode(_window.get_window_id()))
	
	ProjectSettings.save_custom("res://override.cfg")

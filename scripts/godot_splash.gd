extends Control

@onready var logo := $Logo

@export var start_delay := 0.5
@export var fade_in_duration := 3.0
@export var on_screen_delay := 1.5
@export var fade_out_duration := 1.0


func _ready():
	logo.modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	tween.tween_property(logo, "modulate", Color.WHITE, fade_in_duration).set_delay(start_delay)
	tween.tween_property(logo, "modulate", Color.TRANSPARENT, fade_out_duration).set_delay(on_screen_delay)
	if DirAccess.dir_exists_absolute("res://proprietary/"):
		tween.tween_callback(get_viewport().change_scene_to_file.bind("res://proprietary/scenes/fita_splash.tscn"))
	else:
		tween.tween_callback(get_viewport().change_scene_to_file.bind("res://scenes/world.tscn"))

extends Control

@export var start_delay := 0.5
@export var fade_in_duration := 2.0
@export var on_screen_delay := 1.0
@export var fade_out_duration := 0.5
@export_file("*.tscn") var next_scene : String

@onready var _logo := $Logo

var _tween : Tween


func _ready():
	_logo.modulate = Color.TRANSPARENT
	
	get_viewport().queue_scene(next_scene)
	
	_tween = create_tween()
	_tween.tween_property(_logo, "modulate", Color.WHITE, fade_in_duration).set_delay(start_delay)
	_tween.tween_property(_logo, "modulate", Color.TRANSPARENT, fade_out_duration).set_delay(on_screen_delay)
	_tween.tween_callback(_change_scene)


func _input(event):
	if event.is_action_pressed("start"):
		_skip_splash()


func _skip_splash():
	var elapsed_time : float = _tween.get_total_elapsed_time()
	var first_tweener_duration : float = start_delay + fade_in_duration
	
	if elapsed_time < first_tweener_duration:
		var time_to_skip : float = first_tweener_duration - elapsed_time
		_tween.custom_step(time_to_skip)
	
	if elapsed_time > first_tweener_duration:
		_logo.modulate = Color.TRANSPARENT
		_tween.kill()
		_change_scene()


func _change_scene():
	get_viewport().change_scene_to_file(next_scene)

extends Control

@export var start_delay := 0.5
@export var fade_in_duration := 2.0
@export var on_screen_delay := 1.0
@export var fade_out_duration := 0.5
@export_group("NextScene")
@export_file("*.tscn") var next_scene : String
@export var to_loading_screen := false

@onready var _logo := $Logo

var _tween : Tween


func _ready():
	_logo.modulate = Color.TRANSPARENT
	
	if not to_loading_screen:
		get_viewport().queue_scene(next_scene)
	
	_tween = create_tween()
	_tween.tween_property(_logo, "modulate", Color.WHITE, fade_in_duration).set_delay(start_delay)
	_tween.tween_property(_logo, "modulate", Color.TRANSPARENT, fade_out_duration).set_delay(on_screen_delay)
	_tween.tween_callback(_change_scene)


func _input(event):
	if not event.is_pressed():
		return
	
	if event.is_action("ui_accept") or event is InputEventScreenTouch:
		_skip_splash()
		return


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
	if to_loading_screen:
		get_viewport().change_to_loading_scene(next_scene)
	else:
		get_viewport().change_scene(next_scene)

extends Control

var _menu_option_button : Resource = preload("res://utilities/menu_scene/menu_option_button.tscn")

@export var options : Array[String]
@export var scenes : Array[String]
@export var loading : Array[bool]

@onready var menu = $VBoxContainer/HBoxContainer/MenuOptions


func _ready():
	_populate_menu()


func _populate_menu():
	var option_size : int = mini(options.size(), scenes.size())
	loading.resize(option_size)
	var prev_button : Button = null
	
	for option in option_size:
		if not ResourceLoader.exists(scenes[option]):
			continue
		
		var button : Button = _create_button(options[option], scenes[option], loading[option])
		menu.add_child(button)
		if prev_button:
			button.focus_neighbor_top = button.get_path_to(prev_button)
			button.focus_previous = button.get_path_to(prev_button)
			prev_button.focus_neighbor_bottom = prev_button.get_path_to(button)
			prev_button.focus_next = prev_button.get_path_to(button)
		prev_button = button
	
	if menu.get_child_count() > 0:
		var first_option : Button = menu.get_child(0) as Button
		var last_option : Button = menu.get_child(-1) as Button
		first_option.focus_neighbor_top = first_option.get_path_to(last_option)
		first_option.focus_previous = first_option.get_path_to(last_option)
		last_option.focus_neighbor_bottom = last_option.get_path_to(first_option)
		last_option.focus_next = last_option.get_path_to(first_option)
		
		first_option.grab_focus.call_deferred()


func _create_button(option : String, scene : String, load_scene : bool) -> Button :
	var new_button : Button = _menu_option_button.instantiate()
	new_button.setup_button(option, scene, load_scene)
	return new_button

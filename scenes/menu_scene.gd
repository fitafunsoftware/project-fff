extends Control

@export var options : Array[String]
@export var scenes : Array[String]

@onready var menu = $VBoxContainer/HBoxContainer/MenuOptions


func _ready():
	_populate_menu()


func _populate_menu():
	var option_size : int = mini(options.size(), scenes.size())
	var prev_button : Button = null
	
	for option in option_size:
		if not ResourceLoader.exists(scenes[option]):
			continue
		
		var button : Button = _create_button(options[option], scenes[option])
		if prev_button:
			button.focus_neighbor_top = prev_button.get_path()
			button.focus_previous = prev_button.get_path()
			prev_button.focus_neighbor_bottom = button.get_path()
			prev_button.focus_next = button.get_path()
		menu.add_child(button)
		prev_button = button
	
	if menu.get_child_count() > 0:
		var first_option : Button = menu.get_child(0) as Button
		var last_option : Button = menu.get_child(-1) as Button
		first_option.focus_neighbor_top = last_option.get_path()
		last_option.focus_neighbor_bottom = first_option.get_path()


func _create_button(option : String, scene : String) -> Button :
	return Button.new()

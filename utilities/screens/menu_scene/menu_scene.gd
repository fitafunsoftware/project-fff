extends Control
## Basic menu scene.
##
## Control Node that creates a basic menu with options that change to different
## scenes.

# The basic menu option button.
var _menu_option_button: Resource = preload("uid://blnfliijmyoe2")

## An array of the menu options to show.
@export var menu_options: Array[MenuOption]

# Container for the menu option buttons.
@onready var _menu = %MenuOptions


func _ready():
	_populate_menu()


# Fill the menu with buttons and set up their UI neighbors.
func _populate_menu():
	var prev_button: Button = null
	
	for option in menu_options:
		if not ResourceLoader.exists(option.scene):
			continue
		
		var button: Button = _create_button(option)
		_menu.add_child(button)
		if prev_button:
			button.focus_neighbor_top = button.get_path_to(prev_button)
			button.focus_previous = button.get_path_to(prev_button)
			prev_button.focus_neighbor_bottom = prev_button.get_path_to(button)
			prev_button.focus_next = prev_button.get_path_to(button)
		prev_button = button
	
	if _menu.get_child_count() > 0:
		var first_option: Button = _menu.get_child(0) as Button
		var last_option: Button = _menu.get_child(-1) as Button
		first_option.focus_neighbor_top = first_option.get_path_to(last_option)
		first_option.focus_previous = first_option.get_path_to(last_option)
		last_option.focus_neighbor_bottom = last_option.get_path_to(first_option)
		last_option.focus_next = last_option.get_path_to(first_option)
		
		first_option.grab_focus.call_deferred()


# Make a button and set it up.
func _create_button(option: MenuOption) -> Button :
	var new_button: Button = _menu_option_button.instantiate()
	new_button.setup_button(option.name, option.scene, option.load_scene, 
			option.touch)
	return new_button

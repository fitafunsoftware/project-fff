class_name VirtualJoypad
extends Control


func _ready():
	GlobalTouchScreen.touch_screen_hidden.connect(hide)
	GlobalTouchScreen.touch_screen_visible.connect(show)
	visible = GlobalTouchScreen.get_visible()

extends Control
class_name VirtualJoypad


func _ready():
	GlobalTouchScreen.touch_screen_hidden.connect(hide)
	GlobalTouchScreen.touch_screen_visible.connect(show)
	visible = GlobalTouchScreen.get_visible()

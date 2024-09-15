extends PanelContainer

signal pressed

@onready var title : Label = $VBoxContainer/Title
@onready var tagline : Label = $VBoxContainer/Tagline
@onready var players : Label = $VBoxContainer/Players


func _gui_input(event: InputEvent) -> void:
	if has_focus():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				pressed.emit()
		
		if event.is_action_pressed("ui_accept"):
			pressed.emit()


func set_room_info(room_info: Dictionary):
	_set_title(room_info["title"])
	_set_tagline(room_info["tagline"])
	_set_players(room_info["players"])


func _set_title(new_title: String):
	title.text = new_title


func _set_tagline(new_tagline: String):
	tagline.text = new_tagline


func _set_players(new_players: Array):
	var new_text : String = "Players: %d/%d" % [new_players[0], new_players[1]]
	players.text = new_text

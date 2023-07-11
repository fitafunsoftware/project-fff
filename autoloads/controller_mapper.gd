extends Node

const GAMECONTROLLERDB_PATH : String = "res://assets/gamecontrollerdb/gamecontrollerdb.txt"

var gamecontrollerdb : Dictionary = {}


func _ready():
	_load()
	_update_current_joypads()
	Input.joy_connection_changed.connect(_joy_connection_changed)


func _load():
	var file : FileAccess = FileAccess.open(GAMECONTROLLERDB_PATH, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var current_line : String = file.get_line()
		if current_line.begins_with('#'):
			continue
		if current_line.is_empty():
			continue
		
		var guid : String = current_line.get_slice(',', 0)
		gamecontrollerdb[guid] = current_line
	
	file.close()


func _update_current_joypads():
	for device_id in Input.get_connected_joypads():
		_add_mapping_from_guid(Input.get_joy_guid(device_id))


func _joy_connection_changed(device, connected):
	if not connected:
		return
	_add_mapping_from_guid(Input.get_joy_guid(device))


func _add_mapping_from_guid(guid : String):
	if not gamecontrollerdb.has(guid):
		return
	
	var mapping : String = gamecontrollerdb[guid]
	Input.remove_joy_mapping(guid)
	Input.add_joy_mapping(mapping, true)

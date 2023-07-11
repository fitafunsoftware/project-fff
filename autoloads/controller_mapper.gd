extends Node

const GAMECONTROLLERDB_PATH : String = "res://assets/gamecontrollerdb/gamecontrollerdb.txt"
const MAPPINGS_PER_FRAME : int = 64

var _gamecontrollerdb : Dictionary = {}
var _file : FileAccess

func _ready():
	_file = FileAccess.open(GAMECONTROLLERDB_PATH, FileAccess.READ)
	_load()
	Input.joy_connection_changed.connect(_joy_connection_changed)


func _load():
	for count in MAPPINGS_PER_FRAME:
		var current_line : String = _file.get_line()
		if current_line.begins_with('#'):
			continue
		if current_line.is_empty():
			continue
		
		var guid : String = current_line.get_slice(',', 0)
		_gamecontrollerdb[guid] = current_line
		
		if _file.get_position() >= _file.get_length():
			break
	
	if _file.get_position() < _file.get_length():
		call_deferred("_load")
		return
	
	_file.close()
	_update_current_joypads()


func _update_current_joypads():
	for device_id in Input.get_connected_joypads():
		_add_mapping_from_guid(Input.get_joy_guid(device_id))


func _joy_connection_changed(device, connected):
	if not connected:
		return
	_add_mapping_from_guid(Input.get_joy_guid(device))


func _add_mapping_from_guid(guid : String):
	if not _gamecontrollerdb.has(guid):
		return
	
	var mapping : String = _gamecontrollerdb[guid]
	Input.remove_joy_mapping(guid)
	Input.add_joy_mapping(mapping, true)

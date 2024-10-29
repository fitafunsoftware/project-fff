extends Node
## Autoload designed to add joy mappings when controllers are connected.
##
## Loads up the SDL_GameControllerDB and adds mappings when a controller 
## is added. Add the autoload if the core controller mapping is outadated and
## you just want to update all of them.
## 
## @tutorial(SDL_GameControllerDB Git Repository): https://github.com/gabomdq/SDL_GameControllerDB
## @deprecated

## Path to the gamecontrollerdb.txt file. This is a submodule in the git repo.[br]
const GAMECONTROLLERDB_PATH: String = "res://assets/gamecontrollerdb/gamecontrollerdb.txt"

## Fallback for the gamecontrollerdb.txt file. In case submodule was not initialized.[br]
const GAMECONTROLLERDB_FALLBACK_PATH: String = "res://utilities/autoloads/gamecontrollerdb.txt"

## Number of lines to read from the file per frame. Distributes the 
## load to not freeze the game.
const LINES_PER_FRAME: int = 64

# The Dictionary that holds the mappings.
var _gamecontrollerdb: Dictionary = {}
# A FileAccess for reading from the file.
var _file: FileAccess

# Open the file. Load the mappings into the Dictionary. 
# Connect to the [signal Input.joy_connection_changed] signal.
func _ready():
	if ResourceLoader.exists(GAMECONTROLLERDB_PATH):
		_file = FileAccess.open(GAMECONTROLLERDB_PATH, FileAccess.READ)
	else: 
		_file = FileAccess.open(GAMECONTROLLERDB_FALLBACK_PATH, FileAccess.READ)
	_load()
	Input.joy_connection_changed.connect(_joy_connection_changed)


# Load the mappings into the Dictionary. Only read up to [constant LINES_PER_FRAME] 
# number of lines every frame. When the file is fully read, close the file, and 
# update the mappings of the currently connected joypads.
func _load():
	for count in LINES_PER_FRAME:
		var current_line: String = _file.get_line()
		if current_line.begins_with('#'):
			continue
		if current_line.is_empty():
			continue
		
		var guid: String = current_line.get_slice(',', 0)
		_gamecontrollerdb[guid] = current_line
		
		if _file.get_position() >= _file.get_length():
			break
	
	if _file.get_position() < _file.get_length():
		call_deferred("_load")
		return
	
	_file.close()
	_update_current_joypads()


# Update the currently connected joypads.
func _update_current_joypads():
	for device_id: int in Input.get_connected_joypads():
		_add_mapping_from_guid(Input.get_joy_guid(device_id))


# Function called when [signal Input._joy_connection_changed] signal is fired.
func _joy_connection_changed(device: int, connected: bool):
	if not connected:
		return
	_add_mapping_from_guid(Input.get_joy_guid(device))


# Remove old mapping then add new mapping based on the mappings in 
# the SDL_GameControllerDB. If the mapping doesn't exist, just return.
func _add_mapping_from_guid(guid: String):
	if not _gamecontrollerdb.has(guid):
		return
	
	var mapping: String = _gamecontrollerdb[guid]
	Input.add_joy_mapping(mapping, true)

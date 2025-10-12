extends Node2D

@warning_ignore_start("integer_division")
@export_category("Stage")
@export var stage_width: int = 640:
	set(value):
		stage_width = clampi(value, 0, 640)
		if _borders:
			_borders.width = stage_width
		if _player:
			_player.max_range = stage_width/2
		_update_width_text()

@export_category("Player")
@export var size: int = 20:
	set(value):
		size = clampi(value, 2, 128)
		if _player:
			_player.size = size
		_update_ratio_text()
		_update_base_text()
		_update_sprint_text()
@export var base_speed: float = 4.0:
	set(value):
		base_speed = value
		if _player:
			_player.base_speed = base_speed
		_update_base_text()
@export var sprint_speed: float = 8.0:
	set(value):
		sprint_speed = value
		if _player:
			_player.sprint_speed = sprint_speed
		_update_sprint_text()

@onready var _player: Node2D = $Player
@onready var _borders: Node2D = $Borders

@onready var _width: Control = $Counters/A/Width
@onready var _size: Control = $Counters/B/Size
@onready var _base: Control = $Counters/C/Base
@onready var _sprint: Control = $Counters/D/Sprint

@onready var _ratio: Label = $Counters/A/Ratio
@onready var _base_pixel_speed: Label = $Counters/C/PixelSpeed
@onready var _base_end_to_end: Label = $Counters/C/EndToEnd
@onready var _sprint_pixel_speed: Label = $Counters/D/PixelSpeed
@onready var _sprint_end_to_end: Label = $Counters/D/EndToEnd


func _ready() -> void:
	_borders.width = stage_width
	_initialize_player()
	_initialize_counters()


func _initialize_player() -> void:
	_player.max_range = stage_width/2
	_player.size = size
	_player.base_speed = base_speed
	_player.sprint_speed = sprint_speed


func _initialize_counters() -> void:
	_width.amount = stage_width
	_size.amount = size
	_base.amount = base_speed * 10
	_sprint.amount = sprint_speed * 10
	
	_update_ratio_text()
	_update_base_text()
	_update_sprint_text()


func _update_width_text() -> void:
	_update_ratio_text()
	_update_base_end_to_end_text()
	_update_sprint_end_to_end_text()


func _update_ratio_text() -> void:
	if _ratio:
		var text: String = "%d.%02dx Player Size"
		var integer: int = stage_width/size
		var fractional: int = posmod(((stage_width*100)/size), 100)
		_ratio.text = text % [integer, fractional]


func _update_base_text() -> void:
	_update_base_pixel_speed_text()
	_update_base_end_to_end_text()


func _update_base_pixel_speed_text() -> void:
	if _base_pixel_speed:
		var text: String = "Pixel Speed: %d"
		var pixel_speed: int = int(size * base_speed)
		_base_pixel_speed.text = text % pixel_speed


func _update_base_end_to_end_text() -> void:
	if _base_end_to_end:
		var text: String = "End To End: %d.%02ds"
		var pixel_speed: float = size * base_speed
		var time: float = stage_width/pixel_speed
		var integer: int = floori(time)
		var fractional: int = posmod(floori(time*100), 100)
		_base_end_to_end.text = text % [integer, fractional]


func _update_sprint_text() -> void:
	_update_sprint_pixel_speed_text()
	_update_sprint_end_to_end_text()


func _update_sprint_pixel_speed_text() -> void:
	if _sprint_pixel_speed:
		var text: String = "Pixel Speed: %d"
		var pixel_speed: int = int(size * sprint_speed)
		_sprint_pixel_speed.text = text % pixel_speed


func _update_sprint_end_to_end_text() -> void:
	if _sprint_end_to_end:
		var text: String = "End To End: %d.%02ds"
		var pixel_speed: float = size * sprint_speed
		var time: float = stage_width/pixel_speed
		var integer: int = floori(time)
		var fractional: int = posmod(floori(time*100), 100)
		_sprint_end_to_end.text = text % [integer, fractional]


func _width_changed(value: int) -> void:
	stage_width = value


func _size_changed(value: int) -> void:
	size = value


func _base_speed_changed(value: int) -> void:
	base_speed = float(value)/10.0


func _sprint_speed_changed(value: int) -> void:
	sprint_speed = float(value)/10.0

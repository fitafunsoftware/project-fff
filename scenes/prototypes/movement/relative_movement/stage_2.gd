extends Node2D

@warning_ignore_start("integer_division")

const STAGE_WIDTH: int = 640

@export_category("Player")
@export var size: int = 20:
	set(value):
		size = clampi(value, 2, 128)
		if _player:
			_player.size = size
		_update_size_text()
@export var height: int = 20:
	set(value):
		height = clampi(value, 2, 256)
		if _player:
			_player.height = height
		_update_height_text()
@export var base_speed: int = 128:
	set(value):
		base_speed = value
		if _player:
			_player.base_speed = base_speed
		_update_base_text()
		_update_sprint_text()
@export var sprint_ratio: float = 1.5:
	set(value):
		sprint_ratio = value
		if _player:
			_player.sprint_ratio = sprint_ratio
		_update_sprint_text()

@onready var _player: Node2D = $Player

@onready var _size: Control = $Counters/A/Size
@onready var _height: Control = $Counters/B/Height
@onready var _base: Control = $Counters/C/Base
@onready var _sprint: Control = $Counters/D/Sprint

@onready var _stage_ratio: Label = $Counters/A/Ratio
@onready var _height_ratio: Label = $Counters/B/Ratio
@onready var _base_ratio: Label = $Counters/C/Ratio
@onready var _base_end_to_end: Label = $Counters/C/EndToEnd
@onready var _sprint_pixel_speed: Label = $Counters/D/PixelSpeed
@onready var _sprint_ratio_label: Label = $Counters/D/Ratio
@onready var _sprint_end_to_end: Label = $Counters/D/EndToEnd


func _ready() -> void:
	_initialize_player()
	_initialize_counters()


func _initialize_player() -> void:
	_player.max_range = STAGE_WIDTH/2
	_player.size = size
	_player.height = height
	_player.base_speed = base_speed
	_player.sprint_ratio = sprint_ratio


func _initialize_counters() -> void:
	_size.amount = size
	_height.amount = height
	_base.amount = base_speed
	_sprint.amount = sprint_ratio * 10
	
	_update_ratio_text()
	_update_height_text()
	_update_base_text()
	_update_sprint_text()


func _update_size_text() -> void:
	_update_ratio_text()
	_update_height_text()
	_update_base_ratio_text()
	_update_sprint_ratio_text()


func _update_ratio_text() -> void:
	if _stage_ratio:
		var text: String = "Stage is %d.%02dx."
		var integer: int = STAGE_WIDTH/size
		var fractional: int = posmod(((STAGE_WIDTH*100)/size), 100)
		_stage_ratio.text = text % [integer, fractional]


func _update_height_text() -> void:
	if _height_ratio:
		var text: String = "%d.%dx Width."
		var integer: int = height/size
		var fractional: int = posmod(height*10/size, 10)
		_height_ratio.text = text % [integer, fractional]


func _update_base_text() -> void:
	_update_base_ratio_text()
	_update_base_end_to_end_text()


func _update_base_ratio_text() -> void:
	if _base_ratio:
		var text: String = "%d.%02dx Size."
		var integer: int = base_speed/size
		var fractional: int = posmod(base_speed*100/size, 100)
		_base_ratio.text = text % [integer, fractional]


func _update_base_end_to_end_text() -> void:
	if _base_end_to_end:
		var text: String = "End To End: %d.%02ds"
		var time: float = float(STAGE_WIDTH)/base_speed
		var integer: int = floori(time)
		var fractional: int = posmod(floori(time*100), 100)
		_base_end_to_end.text = text % [integer, fractional]


func _update_sprint_text() -> void:
	_update_sprint_pixel_speed_text()
	_update_sprint_ratio_text()
	_update_sprint_end_to_end_text()


func _update_sprint_pixel_speed_text() -> void:
	if _sprint_pixel_speed:
		var text: String = "Pixel Speed: %d"
		var pixel_speed: int = int(base_speed * sprint_ratio)
		_sprint_pixel_speed.text = text % pixel_speed


func _update_sprint_ratio_text() -> void:
	if _sprint_ratio_label:
		var text: String = "%d.%02dx Size."
		var sprint_speed:float = base_speed*sprint_ratio
		var integer: int = floori(sprint_speed/size)
		var fractional: int = posmod(floori(sprint_speed*100/size), 100)
		_sprint_ratio_label.text = text % [integer, fractional]


func _update_sprint_end_to_end_text() -> void:
	if _sprint_end_to_end:
		var text: String = "End To End: %d.%02ds"
		var pixel_speed: float = base_speed * sprint_ratio
		var time: float = STAGE_WIDTH/pixel_speed
		var integer: int = floori(time)
		var fractional: int = posmod(floori(time*100), 100)
		_sprint_end_to_end.text = text % [integer, fractional]


func _size_changed(value: int) -> void:
	size = value


func _height_changed(value: int) -> void:
	height = value


func _base_speed_changed(value: int) -> void:
	base_speed = value


func _sprint_ratio_changed(value: int) -> void:
	sprint_ratio = float(value)/10.0

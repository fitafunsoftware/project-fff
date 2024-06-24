@tool
extends Node3D
class_name PixelPositionHelper

static var PIXEL_SIZE : float = NAN
static var FLOOR_GRADIENT : float = NAN

@export_range(-100000, 100000, 1, "suffix:px", "hide_slider") var z_pixel_offset : int = 0 :
	set(value):
		z_pixel_offset = value
		position.z = _get_position_offset()
		z_offset = 0.0

@export var z_offset : float :
	set(value):
		z_offset = _get_position_offset()


func _get_position_offset() -> float:
	if [PIXEL_SIZE, FLOOR_GRADIENT].has(NAN):
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_GRADIENT = GlobalParams.get_global_param("FLOOR_GRADIENT")
	
	return z_pixel_offset * PIXEL_SIZE / FLOOR_GRADIENT

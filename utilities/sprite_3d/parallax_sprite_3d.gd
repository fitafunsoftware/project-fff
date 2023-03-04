extends Sprite3D
class_name ParallaxSprite3D

@export var x_scale : float = 0.0
@export var y_scale : float = 0.0
@export var z_scale : float = 0.0

var PIXEL_SIZE : float = GlobalParams.get_global_param("PIXEL_SIZE")
@onready var _prev_position : Vector3 = global_position
var _left_over := Vector3.ZERO


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _process(_delta):
	var displacement : Vector3 = _prev_position - global_position
	var scaled_displacement : Vector3 = displacement * Vector3(x_scale, y_scale, z_scale)
	var total_displacement : Vector3 = scaled_displacement + _left_over
	var snapped_displacement : Vector3 = snapped(total_displacement, Vector3(PIXEL_SIZE, PIXEL_SIZE, PIXEL_SIZE))
	
	position += Vector3(snapped_displacement.x, snapped_displacement.y + snapped_displacement.z, 0.0)
	
	_prev_position = global_position
	_left_over = total_displacement - snapped_displacement

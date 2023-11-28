@tool
@icon("res://utilities/camera/Camera3D.svg")
class_name CameraFollowBody
extends Entity
## 3D node that acts as a camera that follows a body.
##
## An [Entity] that also acts as a camera. Is used to follow a target while also
## being able to be blocked by physics bodies. As such, you can have walls that
## only block camera bodies, but not other entities. This is how you set
## camera boundaries.

## Speed of the camera body.
@export_range(0.0, 10.0, 0.01, "or_greater", "suffix:m/s", "hide_slider")
var speed : float = 5.0

## Target for the camera body to follow.
@export var target : Node3D

## Offset of the target from the center of the screen in pixels.
@export_range(-180, 180, 1, "or_greater", "or_less", "suffix:px", "hide_slider")
var center_height_offset : int = 0 :
	set(value):
		center_height_offset = value
		if is_instance_valid(_camera):
			_move_camera()

## The amount of horizontal screen pixels a target can be from the camera body
## in the x direction.
@export_range(0, 320, 1, "or_greater", "suffix:px", "hide_slider")
var x_drag_margin : int = 0

## The amount of positive vertical screen pixels a target can be from the
## camera body in the y direction (affected by center height offset).
@export_range(0, 180, 1, "or_greater", "suffix:px", "hide_slider")
var y_drag_margin : int = 0

## The amount of negative vertical screen pixels a target can be from the 
## camera body in the y direction (affected by center height offset).
@export_range(0, 180, 1, "or_greater", "suffix:px", "hide_slider")
var negative_y_drag_margin : int = 0

## The amount of vertical screen pixels a target can be from the camera body
## in the z direction (affected by center height offset).
@export_range(0, 180, 1, "or_greater", "suffix:px", "hide_slider")
var z_drag_margin : int = 0

## Is the camera the current camera for the viewport.
@export var current : bool = false :
	set(value):
		current = value
		if is_instance_valid(_camera):
			_camera.current = current

# Global constants that are defined in the relevant json.
static var CAMERA_Y_OFFSET : float = NAN
static var CAMERA_Z_OFFSET : float = NAN
static var ARC_HEIGHT : float = NAN
static var HALF_CHORD_LENGTH : float = NAN
static var RADIUS : float = NAN

@onready var _input_handler : CameraFollowInputHandler = $CameraFollowInputHandler
@onready var _camera : Camera3D = $Camera3D


# Load globals and prepare the body.
func _ready():
	super()
	if [PIXEL_SIZE, FLOOR_GRADIENT, CAMERA_Y_OFFSET, CAMERA_Z_OFFSET,
			ARC_HEIGHT, HALF_CHORD_LENGTH, FLOOR_GRADIENT, RADIUS].has(NAN):
		CAMERA_Y_OFFSET = GlobalParams.get_global_shader_param("CAMERA_Y_OFFSET")
		CAMERA_Z_OFFSET = GlobalParams.get_global_shader_param("CAMERA_Z_OFFSET")
		ARC_HEIGHT = GlobalParams.get_global_shader_param("ARC_HEIGHT")
		HALF_CHORD_LENGTH = GlobalParams.get_global_shader_param("HALF_CHORD_LENGTH")
		RADIUS = GlobalParams.get_global_shader_param("RADIUS")
	
	_camera.current = current
	_move_camera()
	_set_input_handler_properties()


# Set values for the input_handler. The input handler is what actually controls 
# the movement of the body.
func _set_input_handler_properties():
	var x_distance : float = x_drag_margin * PIXEL_SIZE
	var y_distance : float = y_drag_margin * PIXEL_SIZE
	var negative_y_distance : float = negative_y_drag_margin * PIXEL_SIZE
	var z_distance : float = z_drag_margin * PIXEL_SIZE / FLOOR_GRADIENT
	
	_input_handler.body = self
	_input_handler.speed = speed
	_input_handler.leash_distance = Vector3(x_distance, y_distance, z_distance)
	_input_handler.negative_y_leash_distance = negative_y_distance
	_input_handler.target = target


func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	super(delta)


# Places the camera the correct distance away from the body based on the above
# export variables.
func _move_camera():
	var offset_pixels_left : int = center_height_offset
	var distance_from_origin : float = CAMERA_Z_OFFSET - HALF_CHORD_LENGTH
	var height_from_origin : float = 0.0
	
	var camera_y_offset_pixels : int = roundi(CAMERA_Y_OFFSET / PIXEL_SIZE)
	var ARC_HEIGHT_pixels : int = roundi(ARC_HEIGHT / PIXEL_SIZE)
	
	offset_pixels_left += camera_y_offset_pixels
	
	if offset_pixels_left > 0:
		if offset_pixels_left > ARC_HEIGHT_pixels:
			offset_pixels_left -= ARC_HEIGHT_pixels
			distance_from_origin += HALF_CHORD_LENGTH
			
			height_from_origin += offset_pixels_left * PIXEL_SIZE
		else:
			var target_height_on_curve = offset_pixels_left * PIXEL_SIZE
			var target_arc_height = RADIUS - (ARC_HEIGHT - target_height_on_curve)
			var target_arc_legth = sqrt(pow(RADIUS, 2.0) - pow(target_arc_height, 2.0))
			
			distance_from_origin += (HALF_CHORD_LENGTH - target_arc_legth) * PIXEL_SIZE
	else:
		distance_from_origin += offset_pixels_left * PIXEL_SIZE * FLOOR_GRADIENT
	
	_camera.position = Vector3(0.0, height_from_origin, distance_from_origin)


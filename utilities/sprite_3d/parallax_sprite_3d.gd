@tool
@icon("res://utilities/sprite_3d/ParallaxBackground3D.svg")
class_name ParallaxBackground3D
extends Sprite3D
## Parallax sprite for 3D.
##
## A helper node to add parallax to 3D scenes. Meant to be used with a
## ViewportTexture and a single ParallaxBackground node to work. This helper node
## set the offset of the ParallaxBackground node based on the 3D X and Z 
## camera positions.

static var PIXEL_SIZE : float = NAN

var _parallax_background : ParallaxBackground
var _current_camera_3D : Camera3D
@onready var _global_y_position : float = global_position.y


func _init():
	# Sets the render priority to a lower default value just so that it
	# gets drawn behind the regular 3D sprites in the scene.
	# Note that render priority only affects meshes with transparency.
	render_priority = -8


func _ready():
	if texture:
		_on_texture_changed()
		texture.changed.connect(_on_texture_changed)
	
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	if is_nan(PIXEL_SIZE):
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")


func _process(_delta):
	if not _current_camera_3D or not _current_camera_3D.current:
		_attach_to_camera()
	
	if not _parallax_background:
		return
	
	_parallax_background.scroll_offset = Vector2(
			_current_camera_3D.global_position.x/PIXEL_SIZE,
			_current_camera_3D.global_position.z/PIXEL_SIZE)
	
	# Set the y position so the sprite stays at the same relative y position.
	global_position.y = _global_y_position


# Attach to the current camera to let the camera deal with movement.
func _attach_to_camera():
	_current_camera_3D = get_viewport().get_camera_3d()
	
	if get_parent():
		get_parent().remove_child(self)
	
	_current_camera_3D.add_child(self)
	position.z = -_current_camera_3D.far + 0.01


func _on_texture_changed():
	if not texture is ViewportTexture:
		return
	
	var parallax_backgrounds : Array = \
			find_children("*", "ParallaxBackground", true, false)
	if parallax_backgrounds.is_empty():
		return
	_parallax_background = parallax_backgrounds[0]

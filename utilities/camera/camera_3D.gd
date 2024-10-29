extends Camera3D
## An extension of the regular Camera3D node with additional functionality.
##
## Script to add functionality to the Camera3D node. Automatically sets the
## camera size.

@onready var _viewport: Viewport = get_viewport()


func _ready():
	_viewport_size_changed()
	_viewport.size_changed.connect(_viewport_size_changed)


# Set the camera size such that the viewport remains "pixel perfect".
func _viewport_size_changed():
	size = _viewport.size.x / 100.0

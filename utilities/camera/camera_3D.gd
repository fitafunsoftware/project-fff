extends Camera3D

@onready var viewport : SubViewport = get_viewport()


func _ready():
	_viewport_size_changed()
	viewport.size_changed.connect(_viewport_size_changed)


func _viewport_size_changed():
	size = viewport.size.x / 100.0

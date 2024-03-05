extends Entity
# Not actually a component you should reuse.
# A simple body to help with camera movement in the ArtLevel.

@export var speed := 5.0


func _ready():
	super()
	gravity = 0.0


func _process(_delta):
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var y := Input.get_axis("ui_cancel", "ui_accept")
	set_y_velocity(y)
	set_velocity_2d(input * speed)
	target_velocity_2d = input * speed

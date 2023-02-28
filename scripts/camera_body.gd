extends CharacterBody3D

@onready var PIXEL_SIZE : float = GlobalParams.get_global_param("PIXEL_SIZE") \
		if not Engine.is_editor_hint() else 0.01
@onready var FLOOR_ANGLE : float = GlobalParams.get_global_shader_param("FLOOR_ANGLE") \
		if not Engine.is_editor_hint() else 0.524

const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

# Get the gravity from the project settings to be synced with RigidBody3D nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	set_up_direction(Vector3.UP)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("a") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("dpleft", "dpright", "dpup", "dpdown")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	_snap_position()


func _snap_position():
	position.x = snappedf(position.x, PIXEL_SIZE)
	position.y = snappedf(position.y, PIXEL_SIZE)
	position.z = snappedf(position.z, PIXEL_SIZE/sin(FLOOR_ANGLE))

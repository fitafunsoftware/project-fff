@tool
class_name CurvedEntityDetector
extends Area3D
## Detector for entities that follows the curved shader.
##
## Detect whether an entity appears behind this one. Uses the areas of the sprites
## to generate the area to detect entities.

## Signal when an entity has been detected. Only emitted for the first entity
## detected.
signal entity_detected
## Signal when entity leaves and no more entities are detected.
signal entity_lost

# Global params. Set them in the proper json.
# Used to calculate the floor_vector.
static var DISTANCE_TO_CHORD : float = NAN
static var HALF_CHORD_LENGTH : float = NAN
## The gradient of the floor for the curved world shader.
static var floor_vector : Vector2 = Vector2.ZERO

@export var refresh : bool = false :
	set(value):
		if Engine.is_editor_hint() and is_node_ready():
			_generate_collision_shapes()

## The sprites to be used as basis for the area.
@export var _sprites : Array[VerticalSprite3D] = [] :
	set(value):
		_sprites = value
		if Engine.is_editor_hint() and is_node_ready():
			_generate_collision_shapes()


func _init():
	monitorable = false


func _ready():
	connect("area_entered", _signal_entity_status)
	connect("area_exited", _signal_entity_status)


# Function to determine whether to emit signals.
func _signal_entity_status(_body: Node3D):
	if get_overlapping_areas().size() > 1:
		return
	
	if has_overlapping_areas():
		entity_detected.emit()
	else:
		entity_lost.emit()


# Create the collision shapes based on the sprites in the array.
func _generate_collision_shapes():
	if [DISTANCE_TO_CHORD, HALF_CHORD_LENGTH].has(NAN):
		DISTANCE_TO_CHORD = GlobalParams.get_global_param("DISTANCE_TO_CHORD")
		HALF_CHORD_LENGTH = GlobalParams.get_global_param("HALF_CHORD_LENGTH")
		floor_vector = Vector2(DISTANCE_TO_CHORD, HALF_CHORD_LENGTH).normalized()
	
	for child in get_children():
		child.queue_free()
	
	for sprite in _sprites:
		if not sprite:
			continue
		var sprite_area : Array = sprite.get_sprite_area()
		var shape_origin : Vector3 = sprite.global_position
		
		var highest_y : float = sprite_area.reduce(
				func cmp_y(accum, point): return accum if accum > point.y else point.y,
				sprite_area[0].y
				)
		
		var convex_polygons : Array = Geometry2D.decompose_polygon_in_convex(sprite_area)
		for polygon in convex_polygons:
			_generate_collision_shape(polygon, shape_origin, highest_y)


# Generate the collision shape based on the values passed in.
func _generate_collision_shape(polygon: Array, shape_origin: Vector3, highest_y: float):
		var points : Array = Array()
		
		points += polygon.map(
			func to_vector3(point):
				if point.y < highest_y:
					var line_intersect = Geometry2D.line_intersects_line(
						Vector2(0, point.y), Vector2.RIGHT,
						Vector2(0, highest_y), floor_vector
					)
					if line_intersect:
						points.append(Vector3(point.x, point.y, line_intersect.x))
				
				return Vector3(point.x, point.y, 0.0)
		)
		
		var collision_shape := CollisionShape3D.new()
		var convex_polygon := ConvexPolygonShape3D.new()
		convex_polygon.points = points
		collision_shape.shape = convex_polygon
		add_child(collision_shape, true)
		collision_shape.global_position = shape_origin
		collision_shape.owner = owner

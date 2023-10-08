@tool
class_name CurvedEntityDetector
extends Area3D

signal entity_detected
signal entity_lost

static var ARC_HEIGHT : float = NAN
static var ARC_LENGTH : float = NAN
static var floor_vector : Vector2 = Vector2.ZERO

@export var _sprites : Array[VerticalSprite3D] = [] :
	set(value):
		_sprites = value
		if Engine.is_editor_hint() and is_node_ready():
			_generate_areas()


func _init():
	monitorable = false


func _ready():
	connect("area_entered", _signal_entity_status)
	connect("area_exited", _signal_entity_status)


func _signal_entity_status(_body: Node3D):
	if get_overlapping_areas().size() > 1:
		return
	
	if has_overlapping_areas():
		emit_signal("entity_detected")
	else:
		emit_signal("entity_lost")


func _generate_areas():
	if floor_vector.is_equal_approx(Vector2.ZERO):
		ARC_HEIGHT = GlobalParams.get_global_shader_param("ARC_HEIGHT")
		ARC_LENGTH = GlobalParams.get_global_shader_param("ARC_LENGTH")
		floor_vector = Vector2(ARC_HEIGHT, -ARC_LENGTH).normalized()
	
	for child in get_children():
		child.queue_free()
	
	for sprite in _sprites:
		var sprite_size : Vector2 = sprite.texture.get_size() * sprite.pixel_size
		var origin_offset : Vector2 = -sprite.offset * sprite.pixel_size
		origin_offset += sprite_size/2.0 if sprite.centered else Vector2.ZERO
		var shape_origin : Vector3 = sprite.global_position - Vector3(origin_offset.x, origin_offset.y, 0.0)
		
		var from_top = Vector2(0.0, sprite_size.y)
		var line_intersect = Geometry2D.line_intersects_line(
			Vector2.ZERO, Vector2.RIGHT,
			from_top, floor_vector
		)
		if not line_intersect:
			continue
		var z_intersect : float = -line_intersect.x
		
		var points = PackedVector3Array([
			Vector3.ZERO,
			Vector3(sprite_size.x, 0.0, 0.0),
			Vector3(sprite_size.x, sprite_size.y, 0.0),
			Vector3(0.0, sprite_size.y, 0.0),
			Vector3(0.0, 0.0, z_intersect),
			Vector3(sprite_size.x, 0.0, z_intersect)
		])
		
		var collision_shape := CollisionShape3D.new()
		var convex_polygon := ConvexPolygonShape3D.new()
		convex_polygon.points = points
		collision_shape.shape = convex_polygon
		add_child(collision_shape)
		collision_shape.global_position = shape_origin
		collision_shape.owner = owner

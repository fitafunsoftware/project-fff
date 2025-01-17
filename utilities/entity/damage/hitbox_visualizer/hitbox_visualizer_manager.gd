@tool
class_name HitboxVisualizerManager
extends Node3D
## Node for generating HitboxVisualizers.
##
## Node to help generate HitboxVisualizers given an array of Hitboxes. Also connects the visibility
## the HitboxVisualizers to the activation status of the corresponding Hitbox.

# Enum for array that holds min and max values of a shape.
enum {MIN_X, MAX_X, MIN_Y, MAX_Y}
## Hitboxes to generate visualizers for.
@export var hitboxes: Array[Hitbox]
## Distance between the meshes that shapes get decomposed to.
@export var distance_between_subdivisions: float = 0.125 # Power of 2 decimal.
## Height of the meshes that get created.
@export var height_of_polyline_meshes: float = 0.25 # Power of 2 decimal.
## Button to regenerate the Hitbox Visualizers.
@export_tool_button("Regenerate Visualizers", "Callable")
var regenerate_visualizers: Callable = _regenerate_visualizers
## The physics layer for the ground that visualizers will snap to. Changing this value updates
## without needing to regenerate.
@export_flags_3d_physics var ground_collision_mask: int = 0:
	set(value):
		ground_collision_mask = value
		_set_ground_collision_mask()
## Color of Hitbox Visualizer meshes. Changing this value updates without needing to regenerate.
@export var color: Color = Color(1.0, 0.0, 0.0, 0.25):
	set(value):
		color = value
		_set_mesh_color()


# Helper function to regenerate Hitbox Visualizers.
func _regenerate_visualizers():
	for child: Node in get_children():
		if child is HitboxVisualizer:
			child.queue_free()	
	
	for hitbox: Hitbox in hitboxes:
		var owner_ids: PackedInt32Array = hitbox.get_shape_owners()
		for owner_id: int in owner_ids:
			for shape_id: int in hitbox.shape_owner_get_shape_count(owner_id):
				var shape_global_position: Vector3 = \
						hitbox.shape_owner_get_owner(owner_id).global_position
				var shape: Shape3D = hitbox.shape_owner_get_shape(owner_id, shape_id)
				var silhouette: PackedVector2Array = _get_silhouette(shape)
				var min_max_values: Array = _get_min_max_values(silhouette)
				var offset := Vector2(min_max_values[MIN_X], min_max_values[MIN_Y])
				var size := Vector2(min_max_values[MAX_X], min_max_values[MAX_Y]) - offset
				silhouette = _offset_silhouette(silhouette, offset)
				var polylines: Array[PackedVector2Array] = _get_polylines(silhouette, size)
				
				var hitbox_visualizer: HitboxVisualizer = HitboxVisualizer.new()
				hitbox_visualizer.name = &"HitboxVisualizer"
				hitbox_visualizer.polylines = polylines
				hitbox_visualizer.color = color
				hitbox_visualizer.ground_collision_mask = ground_collision_mask
				hitbox_visualizer.height_of_polyline_meshes = height_of_polyline_meshes
				add_child(hitbox_visualizer, Engine.is_editor_hint())
				hitbox_visualizer.global_position = shape_global_position + Vector3(offset.x, 0.0, offset.y)
				hitbox_visualizer.owner = owner
				hitbox_visualizer.hitbox = hitbox
				hitbox_visualizer.generate_meshes.call_deferred()


# Helper function to set ground collision mask on child Hitbox Visualizers.
func _set_ground_collision_mask():
	for child: Node in get_children():
		if child is HitboxVisualizer:
			child.ground_collision_mask = ground_collision_mask


# Helper function to set mesh colors of child Hitbox Visualizers.
func _set_mesh_color():
	for child: Node in get_children():
		if child is HitboxVisualizer:
			child.color = color


# Return the silhouette of the given shape.
func _get_silhouette(shape: Shape3D) -> PackedVector2Array:
	var debug_mesh: ArrayMesh = shape.get_debug_mesh()
	var convex_shape: ConvexPolygonShape3D = \
			debug_mesh.create_convex_shape(false, false)
	var points: Array = Array(convex_shape.points)
	
	points = points.map(
		func(point: Vector3):
			return Vector2(point.x, point.z)
	)
	var convex_hull: PackedVector2Array = Geometry2D.convex_hull(points)
	return convex_hull


# Returns the min and max x and y values of the given silhouette.
func _get_min_max_values(silhouette: PackedVector2Array) -> PackedFloat32Array:
	var first_point: Vector2 = silhouette.get(0)
	var values: PackedFloat32Array = [first_point.x, first_point.x, first_point.y, first_point.y]
	
	for point: Vector2 in silhouette:
		values[MIN_X] = minf(point.x, values[MIN_X])
		values[MAX_X] = maxf(point.x, values[MAX_X])
		values[MIN_Y] = minf(point.y, values[MIN_Y])
		values[MAX_Y] = maxf(point.y, values[MAX_Y])
	
	return values


# Returns the given silhouette offset by the given offset.
func _offset_silhouette(silhouette: PackedVector2Array, offset: Vector2) -> PackedVector2Array:
	var offset_silhouette := PackedVector2Array()
	for point: Vector2 in silhouette:
		offset_silhouette.append(point - offset)
	return offset_silhouette


# Returns an array of polylines that span the given silhouette each at distance_between_subdivisions
# length away from the other polylines. Size is the max x and y value of the silhouette. The
# silhouette is assumed to have been translated to the origin point, thus having a min x and y of
# zero for both.
func _get_polylines(silhouette: PackedVector2Array, size: Vector2) -> Array[PackedVector2Array]:
	var polylines: Array[PackedVector2Array]
	
	if not silhouette.is_empty():
		var current_depth: float = size.y
		while current_depth >= 0.0:
			var polyline: PackedVector2Array = [
				Vector2(0.0, current_depth),
				Vector2(size.x, current_depth)
			]
			var new_lines_array: Array[PackedVector2Array] = \
					Geometry2D.intersect_polyline_with_polygon(polyline, silhouette)
			polylines.append_array(new_lines_array)
			current_depth -= distance_between_subdivisions
	
	return polylines

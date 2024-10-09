@tool
class_name HitboxVisualizerManager
extends Node3D

enum {MAX_X, MIN_X, MAX_Y, MIN_Y}

@export_tool_button("Regenerate Visualizers", "Callable")
var regenerate_visualizers : Callable = _regenerate_visualizers

@export var distance_between_subdivisions : float = 0.1


func _regenerate_visualizers():
	pass


func _get_silhouette(shape : Shape3D) -> PackedVector2Array:
	var debug_mesh : ArrayMesh = shape.get_debug_mesh()
	var convex_shape : ConvexPolygonShape3D = \
			debug_mesh.create_convex_shape(false, false)
	var points : Array = Array(convex_shape.points)
	
	points = points.map(
		func(point : Vector3):
			return Vector2(point.x, point.z)
	)
	var convex_hull : PackedVector2Array = Geometry2D.convex_hull(points)
	return convex_hull


func _get_subdivided_silhouette(silhouette : PackedVector2Array) -> PackedVector2Array:
	if silhouette.is_empty():
		return silhouette
	
	var values : Array = _get_max_min_values(silhouette)
	var current_depth : float = values[MIN_Y] + distance_between_subdivisions
	var new_points : PackedVector2Array = PackedVector2Array()
	while current_depth < values[MAX_Y]:
		var polyline : PackedVector2Array = [
			Vector2(values[MIN_X], current_depth),
			Vector2(values[MAX_X], current_depth)
		]
		var new_points_array : Array[PackedVector2Array] = \
				Geometry2D.intersect_polyline_with_polygon(polyline, silhouette)
		for array : PackedVector2Array in new_points_array:
			new_points.append_array(array)
		current_depth += distance_between_subdivisions
	
	silhouette.append_array(new_points)
	silhouette = Geometry2D.convex_hull(silhouette)
	return silhouette


func _get_max_min_values(silhouette : PackedVector2Array) -> Array:
	var first_point : Vector2 = silhouette.get(0)
	var values : Array = [first_point.x, first_point.x, first_point.y, first_point.y]
	
	for point : Vector2 in silhouette:
		values[MAX_X] = maxf(point.x, values[MAX_X])
		values[MIN_X] = minf(point.x, values[MIN_X])
		values[MAX_Y] = maxf(point.y, values[MAX_Y])
		values[MIN_Y] = minf(point.y, values[MIN_Y])
	
	return values

@tool
class_name SpriteAreaPolygon
extends Polygon2D
## Helper node to draw area polygons.
##
## A helper node to draw the area of a polygon that encompasses the sprite. This
## area can be used with the [CurvedEntityDetector] to generate better areas for
## sprites.

## The total height of the sprite.[br]
## Required for reorienting the points, as positive y is down in 2D and up in 3D.
@export_range(0, 10000, 1, "hide_slider", "suffix:px") var height: int = 0


func _init():
	color = Color.TRANSPARENT


## Returns the sprite area as a PackedVector2Array of global points.[br]
## Points are reoriented to positive y being up if [member SpriteAreaPolygon.height]
## is properly set.
func get_sprite_area() -> PackedVector2Array:
	var global_points: Array = global_transform * polygon
	global_points = global_points.map(
		func offset(point):
			return Vector2(point.x, abs(point.y - height)).round()
	)
	return PackedVector2Array(global_points)

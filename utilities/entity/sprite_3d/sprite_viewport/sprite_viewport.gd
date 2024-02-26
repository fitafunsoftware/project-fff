@tool
@icon("sprite_viewport.png")
extends SubViewport
class_name SpriteViewport
## SubViewport for use with ViewportTexture to make sprites.
##
## The CanvasItems have a lot of useful features that would be nice to use for
## 3D sprites. This SubViewport helps you to use CanvasItems that can then be
## used as a ViewportTexture in a Sprite3D.


## Button to just calculate SubViewport size.
@export var calculate_size : bool = false :
	set(value):
		_set_size()
		calculate_size = false


# Initial settings that help with using this as a SubViewport for sprites.
func _init():
	transparent_bg = true
	canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST


## Get the area of the sprite.[br]
## Will return the area given by the SpriteAreaPolygon
## if one exists, or an empty PackedVector2Array if it does not exist.
func get_sprite_area() -> PackedVector2Array:
	var polygon2d_children : Array = find_children("*", "Polygon2D")
	if polygon2d_children.size() > 0:
		for child in polygon2d_children:
			if child is SpriteAreaPolygon:
				return child.get_sprite_area()
	
	return PackedVector2Array()


# Sets the size of the SubViewport based on Sprite2D rects.
func _set_size():
	var rect : Rect2i = _get_bounding_rect()
	size = rect.size


func _get_bounding_rect() -> Rect2i:
	var rect : Rect2i = Rect2i()
	rect = _get_child_bounding_rect(self, rect)
	return rect


func _get_child_bounding_rect(node: Node, rect: Rect2i) -> Rect2i:
	for child in node.get_children():
		if child is Sprite2D:
			var child_rect : Rect2 = child.get_rect()
			child_rect.position = child.to_global(child_rect.position)
			rect = rect.merge(child_rect)
		
		if child.get_child_count() > 0:
			rect = _get_child_bounding_rect(child, rect)
	
	return rect

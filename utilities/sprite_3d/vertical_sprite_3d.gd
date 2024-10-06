@tool
class_name VerticalSprite3D
extends Sprite3D
## 3D Sprite for Curved Shader.
##
## The basic Sprite3D node for the Curved World Shader. Unlike HorizontalSprite3D,
## you can use transparent textures as these will be at a single depth level 
## instead of multiple depth levels.

## Max half screen height for custom aabb.
const MAX_SCREEN_HEIGHT : float = 2.4

## The shader for VerticalSprite3D meshes.
static var SHADER : Shader = preload("res://shaders/transparent_mesh.gdshader")
# Set the properties in the appropriate json file.
static var PIXEL_SIZE : float = NAN
static var FLOOR_GRADIENT : float = NAN

@onready var _occluder : Occluder = Occluder.new()
@onready var _current_camera : Camera3D = get_viewport().get_camera_3d()

## Opacity of the Sprite when an entity is detected behind it.
@export_range(0.0, 1.0, 0.1) var entity_detected_opacity : float = 0.5
## Helper to move sprite by a pixel offset relative to parent.
@export_range(-100000, 100000, 1, "suffix:px", "hide_slider") var z_pixel_offset : int = 0
## Button to add the z_pixel_offset to the current position.
@export_tool_button("Add Z Pixel Offset", "Callable")
var add_offset : Callable = _add_offset_to_position


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _set(property: StringName, value: Variant):
	if property == "shaded":
		shaded = value
		_apply_texture()
		return true
	if property in ["texture", "hframes", "vframes", 
			"offset", "centered", "pixel_size"]:
		_set_custom_aabb.call_deferred()
		return false
	
	return false


func _ready() -> void:
	if not material_override:
		_apply_material_override()
	
	_apply_texture()
	texture_changed.connect(_apply_texture)
	if not Engine.is_editor_hint():
		global_position = GlobalParams.get_snapped_position(global_position)


func _process(_delta):
	if not Engine.is_editor_hint():
		_occlude()


## Get the area occupied by the sprite. Defaults to the texture rect if there is
## no defined area.
func get_sprite_area() -> PackedVector2Array:
	var texture_size : Vector2 = texture.get_size() / Vector2(hframes, vframes)
	texture_size = texture_size.round()
	var offset_transform : Transform2D = Transform2D(0, Vector2.ZERO)
	offset_transform = offset_transform.translated(-offset)
	offset_transform = offset_transform.translated(float(centered)*texture_size/2)
	var array : Array = [
		Vector2(0, 0),
		Vector2(texture_size.x, 0),
		texture_size,
		Vector2(0, texture_size.y)
	]
	
	if texture is ViewportTexture:
		var viewport = find_child("SpriteViewport")
		if viewport and viewport is SpriteViewport:
			var sprite_array : Array = viewport.get_sprite_area()
			if sprite_array.size() > 0:
				array = sprite_array
	
	var offset_array : Array = array.map(func transform(vector): return vector*offset_transform)
	var scaled_array : Array = offset_array.map(func scale(vector): return vector*pixel_size)
	var packed_array : PackedVector2Array = PackedVector2Array(scaled_array)
	
	return packed_array


## Sets the opacity of the sprite directly through the shader itself. Don't call
## often as it is not performant to pipe data to the shaders.
func set_shader_opacity(opacity: float):
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("opacity", opacity)


func _apply_material_override():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = SHADER
	shader_material.resource_local_to_scene = true
	material_override = shader_material


func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
	shader_material.set_shader_parameter("shaded", shaded)
	
	if texture is ViewportTexture:
		var viewport = find_child("SpriteViewport")
		if viewport and viewport is SpriteViewport:
			_occluder.set_height(viewport.size.y * pixel_size)
	else:
		_occluder.set_height(texture.get_size().y * pixel_size)


func _set_custom_aabb():
	var texture_size : Vector2 = texture.get_size() / Vector2(hframes, vframes)
	texture_size = texture_size.round()
	var position_offset : Vector2 = (offset - (float(centered)*texture_size/2.0))
	position_offset = position_offset * pixel_size
	var aabb_position : Vector3 = Vector3(0.0, -MAX_SCREEN_HEIGHT, 0.0) \
			+ Vector3(position_offset.x, position_offset.y, 0.0)
	var aabb_size : Vector3 = Vector3(texture_size.x, texture_size.y, 0.0)*pixel_size
	var y_height : float = GlobalParams.get_global_param("ARC_HEIGHT") \
			+ MAX_SCREEN_HEIGHT
	aabb_size.y = aabb_size.y + y_height
	custom_aabb = AABB(aabb_position, aabb_size)


func _occlude():
	if not _current_camera.current:
		_current_camera = get_viewport().get_camera_3d()
	
	var camera_position = _current_camera.global_position
	if _occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()


func _add_offset_to_position():
	if NAN in [PIXEL_SIZE, FLOOR_GRADIENT]:
		PIXEL_SIZE = GlobalParams.get_global_param("PIXEL_SIZE")
		FLOOR_GRADIENT = GlobalParams.get_global_param("FLOOR_GRADIENT")
	var z_offset : float = z_pixel_offset * PIXEL_SIZE / FLOOR_GRADIENT
	position.z += z_offset


func _on_entity_detected():
	set_shader_opacity(entity_detected_opacity)


func _on_entity_lost():
	set_shader_opacity(1.0)


func _on_look_direction_changed(look_direction: int):
	flip_h = look_direction == LookDirection.Direction.LEFT

@tool
class_name VerticalSprite3D
extends Sprite3D
## 3D Sprite for Curved Shader.
##
## The basic Sprite3D node for the Curved World Shader. Unlike HorizontalSprite3D,
## you can use transparent textures as these will be at a single depth level 
## instead of multiple depth levels.

@onready var _occluder : Occluder = Occluder.new()
@onready var _current_camera : Camera3D = get_viewport().get_camera_3d()

## Opacity of the Sprite when an entity is detected behind it.
@export_range(0.0, 1.0, 0.1) var entity_detected_opacity : float = 0.5


func _init():
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _ready() -> void:
	if not material_override:
		_apply_material_override()
	
	_apply_texture()
	texture_changed.connect(_apply_texture)


func _process(_delta):
	if not Engine.is_editor_hint():
		_occlude()


## Get the area occupied by the sprite. Defaults to the texture rect if there is
## no defined area.
func get_sprite_area() -> PackedVector2Array:
	var texture_size : Vector2 = texture.get_size()
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
	if shaded:
		shader_material.shader = load("res://shaders/transparent_mesh_shaded.gdshader")
	else:
		shader_material.shader = load("res://shaders/transparent_mesh_unshaded.gdshader")
	shader_material.resource_local_to_scene = true
	
	material_override = shader_material


func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
	
	if texture is ViewportTexture:
		var viewport = find_child("SpriteViewport")
		if viewport and viewport is SpriteViewport:
			_occluder.set_height(viewport.size.y * pixel_size)
	else:
		_occluder.set_height(texture.get_size().y * pixel_size)


func _occlude():
	if not _current_camera.current:
		_current_camera = get_viewport().get_camera_3d()
	
	var camera_position = _current_camera.global_position
	if _occluder.to_occlude(global_position.z, camera_position.z):
		hide()
	else:
		show()


func _on_entity_detected():
	set_shader_opacity(entity_detected_opacity)


func _on_entity_lost():
	set_shader_opacity(1.0)


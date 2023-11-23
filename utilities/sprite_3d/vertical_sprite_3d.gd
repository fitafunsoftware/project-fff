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


## Sets the opacity of the sprite directly through the shader itself. Don't call
## often as it is not performant to pipe data to the shaders.
func set_shader_opacity(opacity: float):
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("opacity", opacity)


func _apply_material_override():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/transparent_mesh.gdshader")
	
	material_override = shader_material


func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
	
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

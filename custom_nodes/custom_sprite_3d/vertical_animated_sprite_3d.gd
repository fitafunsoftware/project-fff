@tool
extends AnimatedSprite3D
class_name VerticalAnimatedSprite3D


func _ready() -> void:
	if not material_override:
		var shader_material : ShaderMaterial = ShaderMaterial.new()
		shader_material.shader = load("res://shaders/vertical.gdshader")
		material_override = shader_material
	
	if sprite_frames:
		_on_frame_changed()
	
	frame_changed.connect(_on_frame_changed)


func _on_frame_changed():
	var current_texture : Texture2D = sprite_frames.get_frame_texture(animation, frame)
	material_override.set_shader_parameter("sprite_texture", current_texture)

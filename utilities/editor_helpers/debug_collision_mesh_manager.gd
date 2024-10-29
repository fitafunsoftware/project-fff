@tool
class_name DebugCollisionMeshManager
extends Node3D

const SHADER: Shader = preload("res://shaders/wireframe_mesh.gdshader")

@export var collision_shapes: Array[CollisionShape3D]:
	set(value):
		collision_shapes = value
		if Engine.is_editor_hint():
			_refresh_meshes()
@export_color_no_alpha var color: Color:
	set(value):
		color = value
		_reassign_color()
@export_tool_button("Refresh Meshes", "MeshInstance3D")
var refresh_meshes: Callable = _refresh_meshes


func _refresh_meshes():
	for child: Node in get_children():
		child.queue_free()
	_create_meshes()


func _reassign_color():
	for child: Node in get_children():
		if child is MeshInstance3D:
			var shader_material: ShaderMaterial = child.material_override
			shader_material.set_shader_parameter("color", color)
			break


func _create_meshes():
	var shader_material := ShaderMaterial.new()
	shader_material.shader = SHADER
	shader_material.set_shader_parameter("color", color)
	
	for collision_shape: CollisionShape3D in collision_shapes:
		if not collision_shape:
			continue
		
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.material_override = shader_material
		var shape: Shape3D = collision_shape.shape
		var mesh: ArrayMesh = shape.get_debug_mesh()
		mesh_instance.mesh = mesh
		
		add_child(mesh_instance)
		mesh_instance.global_transform = collision_shape.global_transform
		mesh_instance.owner = owner

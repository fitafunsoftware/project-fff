@tool
class_name HitboxVisualizer
extends Node3D
## Helper node to visualize Hitboxes.
##
## Helper node to visualize Hitboxes. Meant to be created by HitboxVisualizerManager instead
## of manually creating. Exported variables are also meant to be set by HitboxVisualizerManager.
## They're exported so they get saved. The constants can be changed to fit your needs.

## Max length of ground raycast.
const MAX_LENGTH: float = 15.0
## Buffer for ground raycast. Starts the raycast from this node's y position plus this buffer.
const QUERY_BUFFER: float = 1.0
## Buffer from ground. Sets the y position to the ground y position plus this buffer.
const BUFFER_SPACE: float = 0.01

## Shader used by the ShaderMaterial of the generated meshes.
static var SHADER: Shader = preload("res://shaders/color_mesh.gdshader")

## Physics layers for the ground.
@export var ground_collision_mask: int = 0
## Color of the meshes.
@export var color: Color:
	set(value):
		color = value
		_set_meshes_colors()
## Height of the generated meshes.
@export var height_of_polyline_meshes: float
## The polylines used to make meshes.
@export var polylines: Array[PackedVector2Array]

# Is the associated hitbox active.
var _hitbox_active: bool = false


func _physics_process(_delta: float):
	_update_visibility()


# Raycast to the ground and set this node's y position. If it can't find the ground, or if the
# hitbox is not active, hide this node and all the mesh children. Function uses the
# PhysicsDirectSpaceState3D thus should only be called in the _physics_process method.
func _update_visibility():
	if not _hitbox_active:
		if visible:
			hide()
		return

	var space_state := get_world_3d().direct_space_state
	
	var origin: Vector3 = global_position + Vector3.UP*QUERY_BUFFER
	var end: Vector3 = origin + Vector3.DOWN*MAX_LENGTH
	var query := PhysicsRayQueryParameters3D.create(origin, end, ground_collision_mask)
	
	var result: Dictionary = space_state.intersect_ray(query)
	if not result.is_empty():
		var final_position = result.position + Vector3.UP*BUFFER_SPACE
		position.y += final_position.y - global_position.y
		visible = _hitbox_active
	else:
		hide()


## Generate meshes to visualize the hitbox. Generated using the polylines array.
func generate_meshes():
	var shader_material := ShaderMaterial.new()
	shader_material.shader = SHADER
	shader_material.set_shader_parameter("color", color)

	for polyline: PackedVector2Array in polylines:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mesh_instance.mesh = _get_mesh(polyline)
		mesh_instance.material_override = shader_material
		mesh_instance.name = &"SubdivisionMesh"
		add_child(mesh_instance, Engine.is_editor_hint())
		mesh_instance.owner = owner
		mesh_instance.position = Vector3(0, 0, polyline[0].y)


## Set whether the associated hitbox is active or not.
func set_hitbox_active(active: bool):
	_hitbox_active = active


func _set_meshes_colors():
	for child: Node in get_children():
		if child is MeshInstance3D:
			var shader_material := child.material_override as ShaderMaterial
			shader_material.set_shader_parameter("color", color)
			break


func _get_mesh(polyline: PackedVector2Array) -> ArrayMesh:
	var mesh_vertices: PackedVector3Array
	for point: Vector2 in polyline:
		mesh_vertices.append(Vector3(point.x, 0.0, 0.0))
		mesh_vertices.append(Vector3(point.x, height_of_polyline_meshes, 0.0))
	
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_normal(Vector3.BACK)
	
	var min_x: float = polyline[0].x
	var max_x: float = polyline[polyline.size() - 1].x

	for vertex: Vector3 in mesh_vertices:
		var uv_x: float = remap(vertex.x, min_x, max_x, 0.0, 1.0)
		var uv_y: float = remap(vertex.y, 0.0, height_of_polyline_meshes, 0.0, 1.0)
		surface_tool.set_uv(Vector2(uv_x, uv_y))
		surface_tool.add_vertex(vertex)
	
	for index: int in mesh_vertices.size() - 2:
		surface_tool.add_index(index)
		
		if index % 2 == 0:
			surface_tool.add_index(index + 1)
		
		surface_tool.add_index(index + 2)
		
		if index % 2 == 1:
			surface_tool.add_index(index + 1)
	
	surface_tool.generate_tangents()
	return surface_tool.commit()

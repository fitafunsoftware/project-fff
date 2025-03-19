extends Node3D


func _ready():
	if not RenderingServer.get_current_rendering_method() == "gl_compatibility":
		$IndicatorLight.queue_free()
		$OverallLight.queue_free()

class_name ShaderDisplacement

const curve_height : float = 0.75
const curve_radius = 7.5
const curve_l = 8.3175
const floor_angle = 0.524


static func get_corresponding_z_distance(height: float) -> float:
	var length : float = 0.0
	
	if height < curve_height:
		var adjacent : float = curve_radius - height
		var theta : float = acos(adjacent / curve_radius)
		length = curve_radius * theta
	else:
		var opposite : float = height - curve_height
		var hypotenuse : float = opposite / sin(floor_angle)
		length = curve_l + hypotenuse
	
	return length

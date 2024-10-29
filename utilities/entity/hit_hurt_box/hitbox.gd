@tool
@icon("hitbox.png")
class_name Hitbox
extends Area3D
## Hitbox for dealing damage to entities.
##
## An Area3D Hitbox for dealing damage to Hurtboxes.

## The HitboxManager responsible for calculating damage packet.
@export var _manager: HitboxManager
## Identifier for the Hitbox.
@export var _type: StringName

# List of previous hurtboxes to not apply damage twice.
var _previous_hurtboxes: Array[Hurtbox]


func _init():
	monitorable = false
	monitoring = true
	input_ray_pickable = false


func _set(property: StringName, value: Variant) -> bool:
	if property == "monitoring":
		if monitoring and not value:
			_previous_hurtboxes.clear()
	return false


func _ready():
	_previous_hurtboxes.assign(Array())
	area_entered.connect(_apply_damage)


func _apply_damage(area: Area3D):
	if area is Hurtbox:
		if area in _previous_hurtboxes:
			return
		
		var damage_packet: Dictionary = _manager.get_damage(_type)
		area.apply_damage(damage_packet)
		
		_previous_hurtboxes.append(area)

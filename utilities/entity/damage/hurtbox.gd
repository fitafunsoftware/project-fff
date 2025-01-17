@tool
@icon("uid://b4vvhnykac6r4")
class_name Hurtbox
extends Area3D
## Hurtbox for receiving damage.
##
## Area3D Hurtbox for receiving damage from Hitboxes.

## HurtboxManager responsible for applying damage.
@export var _manager: HurtboxManager
## Identifier for the Hurtbox.
@export var _section: StringName


func _init():
	monitorable = true
	monitoring = false
	input_ray_pickable = false


## Applies damage to Entity based on the damage packet passed in.
func apply_damage(damage_packets: Array[DamagePacket]):
	_manager.apply_damage(_section, damage_packets)

@icon("uid://bsb4p254s43um")
class_name HitboxManager
extends Node3D
## Manager for hitboxes.
##
## Manager to help calculate and create damage packets for Hitboxes.

## Body these Hitboxes are connected to.
@export var _body: Entity


## Get damage packet to be sent by Hitbox.
func get_damage(_type: String) -> Dictionary[StringName, Variant]:
	var damage_packet: Dictionary[StringName, Variant]
	damage_packet.assign(Dictionary())
	damage_packet["body"] = _body
	
	return damage_packet

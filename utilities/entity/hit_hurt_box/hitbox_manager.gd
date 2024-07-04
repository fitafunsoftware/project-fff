@icon("hitbox_manager.png")
class_name HitboxManager
extends Node3D
## Manager for hitboxes.
##
## Manager to help calculate and create damage packets for Hitboxes.

## Body these Hitboxes are connected to.
@export var _body : Entity


## Get damage packet to be sent by Hitbox.
func get_damage(_type: String) -> Dictionary:
	var damage_packet : Dictionary = {}
	damage_packet["body"] = _body
	
	return damage_packet

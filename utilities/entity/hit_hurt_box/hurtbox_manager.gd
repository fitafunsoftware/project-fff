@icon("uid://7hj3a0pwkrp6")
class_name HurtboxManager
extends Node3D
## Manager for hurtboxes.
##
## Manager to help calculate and create damage packets for Hurtboxes.

## Body these Hurtboxes are connected to.
@export var _body: Entity


## Apply damage received by Hurtboxes.
func apply_damage(_section: String, damage_packet: Dictionary[StringName, Variant]):
	var other_body: Entity = damage_packet["body"]
	if other_body == _body:
		return

@icon("uid://bsb4p254s43um")
class_name HitboxManager
extends Node3D
## Manager for hitboxes.
##
## Manager to help calculate and create damage packets for Hitboxes.

## Body these Hitboxes are connected to.
@export var body: Entity
## Sources of damage to get DamagePackets from.
@export var damage_sources: Array[Node]


## Get damage packet to be sent by Hitbox.
func get_damage(type: StringName) -> Array[DamagePacket]:
	var damage_packets: Array[DamagePacket] = Array([], TYPE_OBJECT, "RefCounted", DamagePacket)
	
	for source: Node in damage_sources:
		if source.has_method("get_damage_packets"):
			var packets: Array[DamagePacket] = source.get_damage_packets(type)
			damage_packets.append_array(packets)
	
	for packet: DamagePacket in damage_packets:
		packet.body = body
	
	return damage_packets

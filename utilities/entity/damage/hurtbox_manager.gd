@icon("uid://7hj3a0pwkrp6")
class_name HurtboxManager
extends Node3D
## Manager for hurtboxes.
##
## Manager to help calculate and create damage packets for Hurtboxes.

## Body these Hurtboxes are connected to.
@export var body: Entity
## Nodes that process the damage packets.
@export var damage_sinks: Array[Node]


## Apply damage received by Hurtboxes.
func apply_damage(section: StringName, damage_packets: Array[DamagePacket]):
	for packet: DamagePacket in damage_packets:
		if packet.body == body:
			continue
		
		for sink: Node in damage_sinks:
			if sink.has_method("apply_damage"):
				sink.apply_damage(section, packet)

class_name DamagePacket
## Resource for holding damage data.

## Body associated with this damage packet.
var body: Entity
## Tags associated with this damage packet. Can be used to help define damage types.
var tags: Array[StringName]
## Amount of damage. Cannot be negative.
var amount: int:
	set(value):
		amount = maxi(value, 0)


@warning_ignore("SHADOWED_VARIABLE")
func _init(body: Entity, tags: Array[StringName], amount: int):
	self.body = body
	self.tags = tags
	self.amount = amount

# Damage
Collection of nodes to help implement damage functionality.

## Damage Packet
Resource designed to hold damage data.

## Hitbox
### Hitbox Node
Area3D node with extended functionality to send damage packets to hurtboxes. To disable hitboxes,
set monitoring to false.

### Hitbox Manager
Node designed to calculate damage and generate damage packets for hitboxes to send.

## Hurtbox
### Hurtbox Node
Area3D node with extended functionality to receive damage packets from hitboxes. To disable 
hurtboxes, set monitarable to false.

### Hurtbox Manager
Node designed to apply damage packets received by hurtboxes to the designated entity.

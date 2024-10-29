class_name BroadcastPacketCodec
extends LocalServerCodec
## Codec for broadcast packets used for local server discovery.
##
## This resource encodes data into a broadcast packet for local server discovery
## and decodes a packet that was encoded by [DiscoveryPacketCodec].


## Is the packet encoded by a [DiscoveryPacketCodec].
func is_valid_packet(packet: PackedByteArray) -> bool:
	var header: PackedByteArray = packet.slice(0, TOTAL_HEADER_SIZE)
	var header_string: String = header.get_string_from_utf8()
	if header_string == HEADER + DISCOVER:
		return true
	
	return false


## Encodes a packet as a broadcast packet.[br]See data dictionary keys defined
## in [LocalServerCodec].
func get_encoded_packet(data: Dictionary) -> PackedByteArray:
	var packet: PackedByteArray = PackedByteArray()
	var keys: Array = data.keys()
	for key: StringName in [ADDRESS, SERVER_PORT, CONNECTIONS, MAX_CONNECTIONS]:
		if not keys.has(key):
			return packet
	
	packet.append_array(HEADER.to_utf8_buffer())
	packet.append_array(BROADCAST.to_utf8_buffer())
	packet.append_array(var_to_bytes(data[ADDRESS]))
	var offset: int = packet.size()
	packet.resize(offset + U16_SIZE + U8_SIZE + U8_SIZE)
	packet.encode_u16(offset, data[SERVER_PORT])
	packet.encode_u8(offset + U16_SIZE, data[CONNECTIONS])
	packet.encode_u8(offset + U16_SIZE + U8_SIZE, data[MAX_CONNECTIONS])
	
	if data.has(EXTRAS):
		for extra in data[EXTRAS]:
			packet.append_array(var_to_bytes(extra))
	
	return packet


## Decodes a packet that was encoded by a [DiscoveryPacketCodec].[br]Only data
## retrieved in the Dictionary is the [constant LocalServerCodec.EXTRAS] array.
func get_decoded_packet(packet: PackedByteArray) -> Dictionary:
	var offset: int = TOTAL_HEADER_SIZE
	var extras: Array = []
	while offset < packet.size():
		var value = packet.decode_var(offset)
		if value == null:
			break
		extras.append(value)
		offset += packet.decode_var_size(offset)
	
	return {EXTRAS:extras} if extras.size() > 0 else Dictionary()

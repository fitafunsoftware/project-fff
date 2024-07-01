class_name DiscoveryPacketCodec
extends LocalServerCodec
## Codec for discovery packets used for local server discovery.
##
## This resource encodes data into a discovery packet for local server discovery
## and decodes a packet that was encoded by [BroadcastPacketCodec].


## Is the packet encoded by a [BroadcastPacketCodec].
func is_valid_packet(packet: PackedByteArray) -> bool:
	var header : PackedByteArray = packet.slice(0, TOTAL_HEADER_SIZE)
	var header_string : String = header.get_string_from_utf8()
	if header_string == HEADER + BROADCAST:
		return true
	
	return false


## Encodes a packet as a broadcast packet.[br]The only data encoded is the
## array stored in the [constant LocalServerCodec.EXTRAS] key.
func get_encoded_packet(data: Dictionary) -> PackedByteArray:
	var packet : PackedByteArray = PackedByteArray()
	packet.append_array(HEADER.to_utf8_buffer())
	packet.append_array(DISCOVER.to_utf8_buffer())
	if data.has(EXTRAS):
		for extra in data[EXTRAS]:
			packet.append_array(var_to_bytes(extra))
	return packet


## Decodes a packet that was encoded by a [BroadcastPacketCodec].[br]See data 
## dictionary keys defined in [LocalServerCodec].
func get_decoded_packet(packet: PackedByteArray) -> Dictionary:
	var offset : int = TOTAL_HEADER_SIZE
	
	if offset >= packet.size():
		return Dictionary()
	var address : String = packet.decode_var(offset) as String
	offset += packet.decode_var_size(offset)
	
	if offset + U16_SIZE + U8_SIZE + U8_SIZE > packet.size():
		return Dictionary()
	var port : int = packet.decode_u16(offset)
	var connections : int = packet.decode_u8(offset + U16_SIZE)
	var max_connections : int = packet.decode_u8(offset + U16_SIZE + U8_SIZE)
	offset += U16_SIZE + U8_SIZE + U8_SIZE
	
	var extras : Array = []
	while offset < packet.size():
		extras.append(packet.decode_var(offset))
		offset += packet.decode_var_size(offset)
	
	var server_info : Dictionary = {
		ADDRESS: address,
		SERVER_PORT: port,
		CONNECTIONS: connections,
		MAX_CONNECTIONS: max_connections,
	}
	
	if extras.size() > 0:
		server_info[EXTRAS] = extras
	
	return server_info

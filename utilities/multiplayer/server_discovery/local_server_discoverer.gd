extends LocalServer
class_name LocalServerDiscoverer

signal server_info_received(server_info: Dictionary)

var udp := PacketPeerUDP.new()
var discovery_packet : PackedByteArray


func _ready():
	udp.set_broadcast_enabled(true)
	udp.set_dest_address(BROADCAST_ADDRESS, PORT)
	_set_discovery_packet()
	local_server_discovery()


func _process(_delta: float) -> void:
	for count in udp.get_available_packet_count():
		var packet : PackedByteArray = udp.get_packet()
		if _is_broadcast_packet(packet):
			_decode_packet(packet)


func local_server_discovery():
	ping_for_local_servers()
	await get_tree().create_timer(5.0).timeout
	local_server_discovery()


func ping_for_local_servers():
	udp.put_packet(discovery_packet)


func _set_discovery_packet():
	discovery_packet = PackedByteArray()
	discovery_packet.append_array(HEADER.to_utf8_buffer())
	discovery_packet.append_array(DISCOVER.to_utf8_buffer())


func _is_broadcast_packet(packet: PackedByteArray) -> bool:
	var header : PackedByteArray = packet.slice(0, HEADER_SIZE + POSTFIX_SIZE)
	var header_string : String = header.get_string_from_utf8()
	if header_string == HEADER + BROADCAST:
		return true
	
	return false


func _decode_packet(packet: PackedByteArray):
	var offset : int = HEADER_SIZE + POSTFIX_SIZE
	var address : String = packet.decode_var(offset) as String
	offset += packet.decode_var_size(offset)
	var port : int = packet.decode_u16(offset)
	var connections : int = packet.decode_u8(offset + 2)
	var max_connections : int = packet.decode_u8(offset + 3)
	offset += 4
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
	
	server_info_received.emit(server_info)

extends LocalServer
class_name LocalServerBroadcaster

const TIMEOUT : float = 30.0

var _server := UDPServer.new()
var _peers : Array[PacketPeerUDP] = []
var _lifetimes : Dictionary = {}

var _broadcast_packet : PackedByteArray


func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		_server.stop()


func _ready():
	_server.listen(PORT)


func _process(delta: float):
	_server.poll()
	if _server.is_connection_available():
		var peer : PacketPeerUDP = _server.take_connection()
		var packet : PackedByteArray = peer.get_packet()
		
		if _is_discovery_packet(packet):
			peer.put_packet(_broadcast_packet)
			_peers.append(peer)
			_lifetimes[peer] = 0.0
		else:
			peer.close()
	
	_check_for_packets()
	_prune_connections()
	_update_lifetimes(delta)


func set_broadcast_info(broadcast_info: Dictionary):
	var keys := broadcast_info.keys()
	for key in [ADDRESS, SERVER_PORT, CONNECTIONS, MAX_CONNECTIONS]:
		if not keys.has(key):
			return
	
	var packet : PackedByteArray = PackedByteArray()
	packet.append_array(HEADER.to_utf8_buffer())
	packet.append_array(BROADCAST.to_utf8_buffer())
	packet.append_array(var_to_bytes(broadcast_info[ADDRESS]))
	var offset : int = packet.size()
	packet.resize(offset + U16_SIZE + U8_SIZE + U8_SIZE)
	packet.encode_u16(offset, broadcast_info[SERVER_PORT])
	packet.encode_u8(offset + U16_SIZE, broadcast_info[CONNECTIONS])
	packet.encode_u8(offset + U16_SIZE + U8_SIZE, broadcast_info[MAX_CONNECTIONS])
	
	if broadcast_info.has(EXTRAS):
		for extra in broadcast_info[EXTRAS]:
			packet.append_array(var_to_bytes(extra))
	
	_broadcast_packet = packet


func _is_discovery_packet(packet: PackedByteArray) -> bool:
	var header : PackedByteArray = packet.slice(0, HEADER_SIZE + POSTFIX_SIZE)
	var header_string : String = header.get_string_from_utf8()
	if header_string == HEADER + DISCOVER:
		return true
	
	return false


func _check_for_packets():
	for peer : PacketPeerUDP in _peers:
		for count in peer.get_available_packet_count():
			var packet = peer.get_packet()
			if _is_discovery_packet(packet):
				peer.put_packet(_broadcast_packet)
				_lifetimes[peer] = 0.0


func _prune_connections():
	var to_erase : Array = []
	for peer : PacketPeerUDP in _peers:
		if _lifetimes[peer] > TIMEOUT:
			to_erase.append(peer)
	for peer : PacketPeerUDP in to_erase:
		_peers.erase(peer)
		_lifetimes.erase(peer)
		peer.close()


func _update_lifetimes(delta: float):
	for peer : PacketPeerUDP in _peers:
		_lifetimes[peer] += delta

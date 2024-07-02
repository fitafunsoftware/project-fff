extends LocalServer
class_name LocalServerDiscoverer

var udp := PacketPeerUDP.new()


func _ready():
	udp.set_broadcast_enabled(true)
	udp.set_dest_address(BROADCAST, PORT)
	local_server_discovery()


func _process(_delta: float) -> void:
	for count in udp.get_available_packet_count():
		print(udp.get_packet().get_string_from_utf8())


func local_server_discovery():
	ping_for_local_servers()
	await get_tree().create_timer(5.0).timeout
	local_server_discovery()


func ping_for_local_servers():
	udp.put_packet("Searching for server.".to_utf8_buffer())

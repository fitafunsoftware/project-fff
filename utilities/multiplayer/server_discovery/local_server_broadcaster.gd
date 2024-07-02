extends LocalServer
class_name LocalServerBroadcaster

var server := UDPServer.new()
var peers := []


func _ready() -> void:
	server.listen(PORT)


func _process(_delta: float):
	server.poll()
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		print("Received data: %s" % [packet.get_string_from_utf8()])
		peer.put_packet("Connection established.".to_utf8_buffer())
		peers.append(peer)
	check_for_packets()


func check_for_packets():
	for peer : PacketPeerUDP in peers:
		for count in peer.get_available_packet_count():
			print("Received: %s" % peer.get_packet().get_string_from_utf8())
			peer.put_packet("Packet received.".to_utf8_buffer())

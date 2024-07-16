@icon("local_server_broadcaster.png")
class_name LocalServerBroadcaster
extends Node
## Node to help with broadcasting server info on the local network.
##
## Underlying local server broadcasting uses UDP to broadcast server info.
## Broadcasts server info to a peer only when it receives a discovery packet
## or if the broadcast info is updated.
## [br]Complementary node to the [LocalServerDiscoverer].
## [br]Note: While this node is inteded to be used for server info broadcasting
## on local networks, you can set the [member SERVER_DISCOVERY_PORT] to any port.

## Signal to relay any discovery info found.
signal discovery_info_received(discovery_info: Dictionary)

## The port that the server listens to. Set its value in the GlobalParams
## JSON.
static var SERVER_DISCOVERY_PORT : int = -1

## The codec used to encode and decode packets.
@export var codec : PacketCodec
## Time it takes to receive no new packets from a peer before pruning the peer.
@export var timeout : float = 30.0

# UDPServer for braodcasting and peer discovery.
var _server := UDPServer.new()
# Array of peers this server has connected to.
var _peers : Array[PacketPeerUDP] = []
# The lifetime of each peer. Used for pruning peers that haven't been active
# within the timeout duration.
var _lifetimes : Dictionary = {}
# The packet to be broadcasted to peers.
var _broadcast_packet : PackedByteArray


func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		_server.stop()


func _ready():
	if SERVER_DISCOVERY_PORT == -1:
		SERVER_DISCOVERY_PORT = GlobalParams.get_global_param("SERVER_DISCOVERY_PORT")
	_server.listen(SERVER_DISCOVERY_PORT)
	set_broadcast_packet({})


func _process(delta: float):
	_server.poll()
	if _server.is_connection_available():
		_handle_new_connection()
	
	_check_for_packets()
	_prune_connections()
	_update_lifetimes(delta)


## Set the info for the broadcast packet. How the packet is encoded
## is determined by the [member codec]. Broadcasts the new packet to all
## connected peers.
func set_broadcast_packet(broadcast_info: Dictionary):
	_broadcast_packet = codec.get_encoded_packet(broadcast_info)
	for peer : PacketPeerUDP in _peers:
		peer.put_packet(_broadcast_packet)


# Handle any new connections found by the server. If the [member codec] 
# validates the packet received by the new peer, the new peer is added to the
# list of peers and the broadcast packet is sent over.[br]If the [member codec]
# does not validate the packet, the new peer is closed.
func _handle_new_connection():
	var peer : PacketPeerUDP = _server.take_connection()
	var packet : PackedByteArray = peer.get_packet()
	
	if codec.is_valid_packet(packet):
		_decode_packet(packet)
		peer.put_packet(_broadcast_packet)
		_peers.append(peer)
		_lifetimes[peer] = 0.0
	else:
		peer.close()


func _check_for_packets():
	for peer : PacketPeerUDP in _peers:
		for count in peer.get_available_packet_count():
			var packet = peer.get_packet()
			if codec.is_valid_packet(packet):
				_decode_packet(packet)
				peer.put_packet(_broadcast_packet)
				_lifetimes[peer] = 0.0


# Decode any discovery packets received.
func _decode_packet(packet: PackedByteArray):
	var discovery_info : Dictionary = codec.get_decoded_packet(packet)
	discovery_info_received.emit(discovery_info)


# Prune any connections that haven't been active within the [member timeout]
# time.
func _prune_connections():
	var to_erase : Array = _peers.filter(
			func(peer): return _lifetimes[peer] > timeout
			)
	for peer : PacketPeerUDP in to_erase:
		_peers.erase(peer)
		_lifetimes.erase(peer)
		peer.close()


func _update_lifetimes(delta: float):
	for peer : PacketPeerUDP in _peers:
		_lifetimes[peer] += delta

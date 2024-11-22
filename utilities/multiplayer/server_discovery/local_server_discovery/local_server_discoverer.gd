@icon("local_server_discoverer.png")
class_name LocalServerDiscoverer
extends Node
## Node to help with server discovery on the local network.
##
## Underlying local server discovery uses UDP to search for servers.
## Routinely broadcasts a discovery packet to find servers.
## [br]Complementary node to the [LocalServerBroadcaster].
## [br]Note: While this node is inteded to be used for server discovery on local
## networks, you can set the [member BROADCAST_ADDRESS] to any address and
## [member SERVER_DISCOVERY_PORT] to any port.

## Signal to relay any broadcast info found.
signal broadcast_info_received(broadcast_info: Dictionary[StringName, Variant])

## The address that packets are broadcast to. Set its value in the
## GlobalParams JSON.
static var BROADCAST_ADDRESS: String = ""
## The port that packets are broadcast to. Set its value in the GlobalParams
## JSON.
static var SERVER_DISCOVERY_PORT: int = -1

## The codec used to encode and decode packets.
@export var codec: PacketCodec
## The time between each search broadcast.
@export var search_delay: float = 2.5

# The PacketPeerUDP used for network communication.
var _udp := PacketPeerUDP.new()
# The packet to be broadcast to search for servers.
var _discovery_packet: PackedByteArray


func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		_udp.close()


func _ready():
	if BROADCAST_ADDRESS.is_empty() or SERVER_DISCOVERY_PORT == -1:
		BROADCAST_ADDRESS = GlobalParams.get_global_param("BROADCAST_ADDRESS")
		SERVER_DISCOVERY_PORT = GlobalParams.get_global_param("SERVER_DISCOVERY_PORT")
	
	_udp.set_broadcast_enabled(true)
	_udp.set_dest_address(BROADCAST_ADDRESS, SERVER_DISCOVERY_PORT)
	set_discovery_packet({})
	
	_local_server_discovery()


func _process(_delta: float):
	_check_for_packets()


## Set the info for the discovery packet. How the packet is encoded
## is determined by the [member codec].
func set_discovery_packet(discovery_info: Dictionary[StringName, Variant]):
	_discovery_packet = codec.get_encoded_packet(discovery_info)


## Broadcasts the discovery packet to the [member BROADCAST_ADDRESS] on the
## [member SERVER_DISCOVERY_PORT] port.
func search_for_local_servers():
	_udp.put_packet(_discovery_packet)


func _check_for_packets():
	for count: int in _udp.get_available_packet_count():
		var packet: PackedByteArray = _udp.get_packet()
		if codec.is_valid_packet(packet):
			_decode_packet(packet)


# Function that is meant to search for local servers every [member search_delay]
# seconds.
func _local_server_discovery():
	search_for_local_servers()
	await get_tree().create_timer(search_delay).timeout
	_local_server_discovery()


# Decodes received packets and emits the data through the
# [signal broadcast_info_received] signal.
func _decode_packet(packet: PackedByteArray):
	var broadcast_info: Dictionary[StringName, Variant] = codec.get_decoded_packet(packet)
	broadcast_info_received.emit(broadcast_info)

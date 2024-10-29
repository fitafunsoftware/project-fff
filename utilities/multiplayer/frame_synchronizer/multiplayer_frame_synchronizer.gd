@icon("multiplayer_frame_synchronizer.png")
class_name MultiplayerFrameSynchronizer
extends Node
## Multiplayer node to help with frame synchronization.

## Signal for when the first packet has been received and used to sync frames.
signal initial_frames_synced()
## Signal for when all packets have been received and used to sync frames.
signal final_frames_synced()

## Number of requests to send and receive before doing final frame sync.
const NUMBER_OF_REQUESTS: int = 7
## Time between requests in seconds.
const DELAY_BETWEEN_REQUESTS := 2.5

## Size of a packet that gets sent and received.
const _PACKET_SIZE: int = 2
## Number of additional values in extended packets.
const _EXTENSIONS: int = 2
## Size of a packet that has been received and done calculations on.
const _EXTENDED_PACKET_SIZE: int = _PACKET_SIZE + _EXTENSIONS
## Indices for values in packets.
enum {REQUEST, SERVER}
## Received and Latency only exist in extended packets.
enum {RECEIVED = _PACKET_SIZE, LATENCY}

# ID of the server.
var _server_id: int = 0
# Compensation in msec to add onto server time.
var _compensation: int = 0
# Array of packets received from time synchronization.
var _packets: Array[PackedInt64Array]


func _ready():
	_packets.assign(Array())


## Function for the [b]server[/b] to request clients start a time sync. 
## [br]Will not be called on self if server is also a client.
@rpc("authority", "call_remote", "reliable", Multiplayer.TIMING_CHANNEL)
func start_time_sync():
	if _packets.size() > 0 and _packets.size() < NUMBER_OF_REQUESTS:
		# Time sync in progress.
		return
	_server_id = multiplayer.get_remote_sender_id()
	_packets.clear()
	request_time()


## Function for the [b]clients[/b] to start a time request.
## [br]Will only be called locally, so it does not need rpc tags.
func request_time():
	var packet: PackedInt64Array = PackedInt64Array()
	packet.resize(_PACKET_SIZE)
	packet[REQUEST] = Time.get_ticks_msec()
	
	request_server_time.rpc_id(_server_id, packet)


## Function for the [b]clients[/b] to request the current time of the server.
@rpc("any_peer", "call_remote", "reliable", Multiplayer.TIMING_CHANNEL)
func request_server_time(packet: PackedInt64Array):
	if not multiplayer.is_server():
		return
	
	packet[SERVER] = Time.get_ticks_msec()
	var sender_id = multiplayer.get_remote_sender_id()
	receive_time.rpc_id(sender_id, packet)


## Function for the [b]server[/b] to send back the packets to the client.
## [br]The first packet received will be used for an initial frame sync. When
## all [constant NUMBER_OF_REQUESTS] packets have been received, a final frame
## sync will be started.
@rpc("authority", "call_remote", "reliable", Multiplayer.TIMING_CHANNEL)
func receive_time(packet: PackedInt64Array):
	packet.resize(_EXTENDED_PACKET_SIZE)
	packet[RECEIVED] = Time.get_ticks_msec()
	packet[LATENCY] = _calculate_latency(packet)
	_packets.append(packet)
	
	if _packets.size() == 1:
		_initial_sync()
	
	if _packets.size() < NUMBER_OF_REQUESTS:
		await get_tree().create_timer(DELAY_BETWEEN_REQUESTS).timeout
		request_time()
	elif _packets.size() == NUMBER_OF_REQUESTS:
		_final_sync()


## Function for the [b]clients[/b] to request the server for a frame sync.
@rpc("any_peer", "call_remote", "reliable", Multiplayer.SYNCING_CHANNEL)
func request_frame_sync():
	if not multiplayer.is_server():
		return
	
	var sender_id: int = multiplayer.get_remote_sender_id()
	var current_frame: int = GlobalParams.get_frame_time()
	var server_time: int = Time.get_ticks_msec()
	sync_frames.rpc_id(sender_id, current_frame, server_time)


## Function for the [b]server[/b] to call to sync frames with the client.
@rpc("authority", "call_remote", "reliable", Multiplayer.SYNCING_CHANNEL)
func sync_frames(current_frame: int, server_time: int):
	GlobalParams.sync_frame_time(current_frame, server_time, _compensation)
	if _packets.size() < NUMBER_OF_REQUESTS:
		initial_frames_synced.emit()
	else:
		final_frames_synced.emit()


# Sync functions.
func _initial_sync():
	var single_packet_array: Array = [_packets.front()]
	_compensation = _calculate_compensation(single_packet_array)
	request_frame_sync.rpc_id(_server_id)


func _final_sync():
	_packets.sort_custom(
			func(packet, to_compare): \
				return packet[LATENCY] < to_compare[LATENCY]
	)
	
	var filtered_packets: Array = _filter_packets()
	_compensation = _calculate_compensation(filtered_packets)
	
	request_frame_sync.rpc_id(_server_id)


# Helper functions
func _calculate_latency(packet: PackedInt64Array) -> int:
	@warning_ignore("integer_division")
	return (packet[RECEIVED] - packet[REQUEST]) / 2


# Returns an array with only the packets that are within 1 standard deviation
# from the median.
func _filter_packets() -> Array:
	@warning_ignore("integer_division")
	var median_packet: PackedInt64Array = _packets[_packets.size()/2] as PackedInt64Array
	var median_latency: int = median_packet[LATENCY]
	var sum: float = 0.0
	for packet: PackedInt64Array in _packets:
		sum += pow(packet[LATENCY] - median_latency, 2.0)
	var standard_deviation = sqrt(sum / (_packets.size() - 1))
	
	return _packets.filter(
			func(packet): \
				return  absi(median_latency - packet[LATENCY]) <= standard_deviation
	)


# Calculate the final compensation to be used.
func _calculate_compensation(packets: Array) -> int:
	var mean_latency: float = 0.0
	var mean_tick_difference: float = 0.0
	for packet: PackedInt64Array in packets:
		mean_latency += packet[LATENCY]
		mean_tick_difference += packet[RECEIVED] - packet[SERVER]
	mean_latency /= packets.size()
	mean_tick_difference /= packets.size()
	
	return int(mean_tick_difference + mean_latency)

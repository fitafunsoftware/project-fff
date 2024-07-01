# PacketCodec
Resources meant to encode and decode PackedByteArray packets. Can be extended to make your own
codecs. Has the following functions to be overriden:
- is_valid_packet(packet: PackedByteArray) -> bool
    - Returns whether or not given packet can be decoded by this codec.
- get_encoded_packet(data: Dictionary) -> PackedByteArray
    - Returns an encoded packet using given codecs encoding.
- get_decoded_packet(packet: PackedByteArray) -> Dictionary
    - Decodes the given packet and returns a Dictionary with the data.

## LocalServerCodec
A group of codecs meant to help with server discovery on local networks.

### BroadcastPacketCodec
Codec for LocalServerBroadcaster. Decodes packets encoded by the DiscoveryPacketCodec.

### DiscoveryPacketCodec
Codec for LocalServerDiscoverer. Decodes packets encoded by the BroadcastPacketCodec.

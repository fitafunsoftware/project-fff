class_name PacketCodec
extends Resource
## Base class for codecs for packets.
##
## Packets sent over the network should ideally be encoded a certain way and
## decoded a certain way. This resource is meant to be a codec that abstracts
## that decoding and encoding functionality.[br]Note: While it's reasonable
## for a codec to be able to decode the packet it encoded, there is no innate
## limitation for that.


## Is [param _packet] a valid packet that this codec can decode?
func is_valid_packet(_packet: PackedByteArray) -> bool:
	return true


## Turns [param _data] into an encoded [PackedByteArray] packet based on this
## codec's encoding method.
func get_encoded_packet(_data: Dictionary[StringName, Variant]) -> PackedByteArray:
	return PackedByteArray()


## Decodes [param _packet] into a [Dictionary] based on this codec's decoding
## method.
func get_decoded_packet(_packet: PackedByteArray) -> Dictionary[StringName, Variant]:
	var empty_typed_dictionary: Dictionary[StringName, Variant]
	return empty_typed_dictionary

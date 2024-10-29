class_name LocalServerCodec
extends PacketCodec
## Base class for local server discovery codecs.
##
## A class just meant to hold constants that are shared between
## [BroadcastPacketCodec] and [DiscoveryPacketCodec]. Use one of those codecs
## instead of this resourse.

## Header for packets.
const HEADER: String = "PFFFv0.1"
## Postfix header for broadcast packets.
const BROADCAST: String = "B"
## Postfix header for discovery packets.
const DISCOVER: String = "D"
## Total size of the header with the postfix attached.
static var TOTAL_HEADER_SIZE: int = HEADER.length() + BROADCAST.length()


## Server address key for the data dictionary.
const ADDRESS: StringName = &"address"
## Server port key for the data dictionary.
const SERVER_PORT: StringName = &"port"
## Number of connections key for the data dictionary.
const CONNECTIONS: StringName = &"connections"
## Max number of connections key for the data dictionary.
const MAX_CONNECTIONS: StringName = &"max_connections"
## Extras key for the data dictionary.[br]Extras should be an array full of
## [Variants] but no [Objects].
const EXTRAS: StringName = &"extras"

# Giving names to magic numbers.
## Number of bytes used by an Unsigned 8-bit integer.
const U8_SIZE: int = 1
## Number of bytes used by an Unsigned 16-bit integer.
const U16_SIZE: int = 2

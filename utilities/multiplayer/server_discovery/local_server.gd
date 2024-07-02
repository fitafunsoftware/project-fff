extends Node
class_name LocalServer

const BROADCAST_ADDRESS : String = "255.255.255.255"
const PORT : int = 9520

const HEADER : String = "PFFFv0.1"
static var HEADER_SIZE : int = HEADER.length()

const BROADCAST : String = "B"
const DISCOVER : String = "D"
static var POSTFIX_SIZE : int = BROADCAST.length()

const ADDRESS : StringName = "address"
const SERVER_PORT : StringName = "port"
const CONNECTIONS : StringName = "connections"
const MAX_CONNECTIONS : StringName = "max_connections"
const EXTRAS : StringName = "extras"

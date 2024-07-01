extends LocalServer
class_name LocalServerBroadcaster

@onready var _server : UDPServer = UDPServer.new()
var _peers : Array = []

func _ready():
	_server.listen(PORT, BROADCAST_ADDRESS)


func _process(_delta: float):
	_server.poll()

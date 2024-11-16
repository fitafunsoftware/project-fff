class_name EntityFunctionCall

var function: StringName
var arguments: Array


func _init(function: StringName, arguments: Array = Array()):
	self.function = function
	self.arguments = arguments

extends Node


func _ready():
	Input.add_joy_mapping("526574726f696420506f636b65742043,Retroid Pocket Flip Controller,a:b1,b:b0,back:b4,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b9,leftstick:b7,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b10,rightstick:b8,righttrigger:a4,rightx:a2,righty:a3,start:b6,x:b3,y:b2,paddle1:b17,paddle2:b18,platform:Android,", true)
	Input.add_joy_mapping("582d426f7820436f6e74726f6c6c6572,Retroid Pocket Flip Controller,a:b0,b:b1,back:b4,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b9,leftstick:b7,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b10,rightstick:b8,righttrigger:a4,rightx:a2,righty:a3,start:b6,x:b2,y:b3,paddle1:b17,paddle2:b18,platform:Android,", true)
	queue_free()

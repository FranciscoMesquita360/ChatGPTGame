extends MarginContainer

var log
var data:Array
var sender:String = "Erick"
var receiver:Chat

func _ready():
	log = $VBoxContainer/Log
	
func connect_chat(_receiver:Chat):
	if _receiver is Chat:
		if not _receiver.is_connected("response_received",Callable(self,"response_received")):
			receiver = _receiver
			receiver.connect("response_received",Callable(self,"response_received"))
			visible = true
	
func disconnect_chat():
	if receiver is Chat:
		if receiver.is_connected("response_received",Callable(self,"response_received")):
			receiver.disconnect("response_received",Callable(self,"response_received"))

func response_received(content):
	data.append(content)
	log.text += content+"\n"
	
func send_message(_sender:String,message:String):
	var msg = _sender+": "+message
	receiver.send_message(_sender,message)
	data.append(msg)
	log.text += msg+"\n"


func _on_input_message_sent(message:String):
	send_message(sender,message)

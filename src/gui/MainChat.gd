extends MarginContainer

var log
var data:Array
var sender:String = "Erick"
var receiver:Chat
var api
var answer_format =  ["Resposta A","Resposta B","Resposta C"]
var button_option_a
var button_option_b
var button_option_c
var type_assist
var enable_type_assit = true
var sender_color = "#4C4A38"
var receiver_color = "#8f00cb"


func _enter_tree():
	type_assist =$VBoxContainer/TypeAssit
	type_assist.visible = false
	button_option_a = $VBoxContainer/TypeAssit/ButtonOptionA
	button_option_b = $VBoxContainer/TypeAssit/ButtonOptionB
	button_option_c = $VBoxContainer/TypeAssit/ButtonOptionC

	api =  APIChatGPT.new()
	add_child(api)
	api.connect_api()
	api.set_custom_headers_value("Content-Type: application/json")
	api.set_custom_headers_value("Authorization: Bearer "+api.api_key)
	api.connect("response_received",Callable(self,"_on_api_response_received"))

func _on_api_response_received(response):
	var response_dic = JSON.parse_string(response)
	if not response_dic.has("error"):
		var content = response_dic.get("choices")[0].get("message").get("content")
		
		var content_dic = JSON.parse_string(content)
		if content_dic is Dictionary:
			var values = content_dic.values()
			
			button_option_a.text = values[0][0]
			button_option_a.tooltip_text = values[0][0]
			button_option_b.text = values[0][1]
			button_option_b.tooltip_text = values[0][1]
			button_option_c.text = values[0][2]
			button_option_c.tooltip_text = values[0][2]
	else:
		print("Error")
		
func generate_possible_answers(_sender,conversation):
	var conversation_str = "considere a seguite conversa presencial: "+JSON.stringify(conversation)+", agora liste 3 respostas possiveis para "+_sender+" no seguinte formato"+JSON.stringify({_sender:answer_format})
	api.send_message(conversation_str)
	
	
func _ready():
	log = $VBoxContainer/Log
	
func connect_chat(_receiver:Chat):
	if _receiver is Chat:
		if not _receiver.is_connected("response_received",Callable(self,"response_received")):
			receiver = _receiver
			receiver.start_conversation(sender)
			receiver.connect("response_received",Callable(self,"response_received"))
			visible = true
			type_assist.visible = enable_type_assit
	
func disconnect_chat():
	if receiver is Chat:
		if receiver.is_connected("response_received",Callable(self,"response_received")):
			receiver.end_conversation(sender)
			receiver.disconnect("response_received",Callable(self,"response_received"))
			type_assist.visible = false
			set_type_assit_default()
			
func set_type_assit_default():
	button_option_a.text = "Ola!"
	button_option_b.text = "O que esta fazendo"
	button_option_c.text = "Qual seu nome?"
	button_option_a.tooltip_text = "Ola!"
	button_option_b.tooltip_text = "O que esta fazendo"
	button_option_c.tooltip_text = "Qual seu nome?"
	log.text = ""
func response_received(content):
	data.append(content)
	var msg = format_text(receiver_color,content)
	log.text += msg+"\n"
	if enable_type_assit:
		if receiver is Chat:
			if receiver.is_connected("response_received",Callable(self,"response_received")):
				var dialogue = receiver.current_conversation.get(sender,[])
				generate_possible_answers(sender,dialogue)
		
func send_message(_sender:String,message:String):
	if receiver is Chat:
		var msg = _sender+": "+message
		receiver.send_message(_sender,msg)
		data.append(msg)
		msg = format_text(sender_color,msg)
		log.text += msg+"\n"

func format_text(color:String,raw_text:String):
	return "[color="+color+"]"+raw_text+"[/color]"
	
func _on_input_message_sent(message:String):
	send_message(sender,message)
	
	
	
func _on_button_option_a_button_down():
	_on_input_message_sent(button_option_a.text)
	pass # Replace with function body.


func _on_button_option_b_button_down():
	_on_input_message_sent(button_option_b.text)
	pass # Replace with function body.


func _on_button_option_c_button_down():
	_on_input_message_sent(button_option_c.text)
	pass # Replace with function body.



func _on_button_close_button_down():
	send_message(sender,"Tchau!")
	disconnect_chat()
	visible = false
	pass # Replace with function body.

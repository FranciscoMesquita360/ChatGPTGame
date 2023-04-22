extends Node
class_name  Chat
var data:Dictionary 
var current_conversation:Dictionary
var conversation_history:Dictionary
var api:APIChatGPT
var name_character:String
var sender_current:String
var last_answer:String
signal response_received



func _init(_data:Dictionary):
	data = _data
	current_conversation = data["current_conversation"]
	conversation_history = data["conversation_history"]
	name_character = data["name"]
	
func _enter_tree():
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
		print (response)
		last_answer = content
		update_response_conversation(sender_current,content)
		response_received.emit(content)
	else:
		response_received.emit("Sistema: Pergunte de novo")
	
func update_response_conversation(sender:String,message:String):
	if current_conversation.has(sender):
		if current_conversation[sender] is Array:
			current_conversation[sender].append(message)
			return
	current_conversation[sender] = [message]

func send_message(sender:String,message:String):
	if current_conversation.has(sender):
		if current_conversation[sender] is Array:
			current_conversation[sender].append(message)
			var chat_str = JSON.stringify(data)
			sender_current = sender
			
			api.send_message(chat_str)
			return
	current_conversation[sender] = [message]
	var chat_str = JSON.stringify(data)
	sender_current = sender
	api.send_message(chat_str)

func end_conversation(sender):
	if current_conversation.has(sender):
		var dialogue_arr = current_conversation.get(sender)
		if dialogue_arr is Array:
			if not dialogue_arr.is_empty():
				var dialogue_history:Array = conversation_history.get(sender,dialogue_arr)
				dialogue_history.append_array(dialogue_arr)
				conversation_history[sender] = dialogue_history
		current_conversation.erase(sender)





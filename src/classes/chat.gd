extends Node
class_name  Chat
var data:Dictionary 
var current_conversation:Dictionary
var conversation_history:Dictionary
var comments:Array
var api:APIChatGPT
var name_character:String
var sender_current:String
var last_answer:String

signal response_received
signal  finished_conversation
var premissa:String


func _init(_data:Dictionary):
	data = _data
	current_conversation = data["current_conversation"]
	conversation_history = data["conversation_history"]
	name_character = data["name"]
	comments = data["comments"]
	premissa = "vamos fingir que estamos em uma consversa presencial, e vocé chatGPT é o personagem "+name_character+", responda de forma curta ao que "+sender_current+" falou em current_conversation e aguarde, sempre coloque "+name_character+": antes da resposta,leve em consideração conversation_history, leve consideração as quests"


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
		content = sanitize_message(content)
		print (response)
		last_answer = content
		update_response_conversation(sender_current,content)
		response_received.emit(content)

	else:
		response_received.emit("Sistema: Pergunte de novo")
		
func sanitize_message(message:String):
	var pos_cut_start = message.find("(")
	var pos_cut_end = -1
	if pos_cut_start > -1:
		pos_cut_end = message.find(")",pos_cut_start)
		var cut_len = pos_cut_end-pos_cut_start
		if cut_len > 0:
			var comments_str:String = message.substr(pos_cut_start,cut_len)
			if not comments.has(comments_str):
				if comments.is_empty():
					pass
					#comments.append(comments_str)
				else:
					pass
					#comments[0] = comments_str

		message = message.left(pos_cut_start)
		
	#pos_cut_start = message.find("?")
	#if pos_cut_start > -1:
	#	message = message.left(pos_cut_start+1)

	message = message.replace("\n"," ")
	message = message.replace("\t"," ")
	
	return message
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
			api.send_message(premissa+chat_str)
			return
	current_conversation[sender] = [message]
	var chat_str = JSON.stringify(data)
	sender_current = sender
	
	api.send_message(premissa+chat_str)


func start_conversation(sender):
	var dialogue_arr = conversation_history.get(sender)
	if dialogue_arr != null:
		current_conversation[sender] = dialogue_arr

func end_conversation(sender):
	if current_conversation.has(sender):
		var dialogue_arr = current_conversation.get(sender)
		conversation_history[sender] = dialogue_arr
		current_conversation.erase(sender)
		finished_conversation.emit(sender)







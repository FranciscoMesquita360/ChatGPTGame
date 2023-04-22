extends Node
class_name Character
var chat:Chat
var data_json
func _init(data_path:String):
	data_json = load(data_path)
	chat = Chat.new(data_json.data.chat)

func _enter_tree():
	add_child(chat)
	
	

func save():
	ResourceSaver.save(data_json,"res://src/data/characters/save/"+data_json.resource_name)

extends TextEdit
var chat_log

var bob:Character
func _ready():
	chat_log = get_tree().get_nodes_in_group("chat_log")[0]

	bob = Character.new("res://src/data/characters/default/Bob.json")
	bob.chat.connect("response_received",Callable(self,"print_response"))
	add_child(bob)
	



func print_response(res):
	chat_log.text += "[color=#ffffff88]"+res+"[/color]"+"\n"


func _on_text_changed():
	if get_line_count() > 1:
		var sender = get_tree().get_nodes_in_group("sender")[0].text
		var msg = sender+": "+text
		chat_log.text += "[color=green]"+msg+"[/color]"+"\n"
		bob.chat.send_message(sender,msg)
		clear()




func _on_button_child_entered_tree(node):
	pass # Replace with function body.

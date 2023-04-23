extends Node2D

var bob:Character
var player
func _ready():
	bob = Character.new("res://src/data/characters/default/Bob.json")
	bob.position.x = 600
	add_child(bob)
	
	player = load("res://src/characters/player/player.tscn").instantiate()
	player.connect("tree_entered",Callable(self,"_on_player_entered_scene"))
	player.position.x = 22
	add_child(player)
	
	

	


func _on_player_entered_scene():
	print(34)
	player.add_child(Camera2D.new())
	pass
	

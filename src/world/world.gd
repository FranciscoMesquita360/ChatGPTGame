extends Node2D

var bob:Character
var galahad:Character
var merlin:Character
var rainha_guinevere:Character

var player
func _ready():
	galahad = Character.new("res://src/data/characters/save/Galahad.json")
	galahad.position.x = 300
	add_child(galahad)
	
	merlin = Character.new("res://src/data/characters/save/Merlin.json")
	merlin.position.x = 1000
	add_child(merlin)
	
	rainha_guinevere = Character.new("res://src/data/characters/save/Rainha Guinevere.json")
	rainha_guinevere.position.x = 1600
	add_child(rainha_guinevere)
	
	
	
	player = load("res://src/characters/player/player.tscn").instantiate()
	player.connect("tree_entered",Callable(self,"_on_player_entered_scene"))
	player.position.x = 22
	add_child(player)
	
	

	


func _on_player_entered_scene():

	player.add_child(Camera2D.new())
	pass
	

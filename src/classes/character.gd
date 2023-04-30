extends CharacterBody2D
class_name Character
var chat:Chat
var data_json
var colision 
var sprite
var enable_motion = false
var gui
var speech_bubble
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var interact_menu
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shape


func _init(data_path:String):
	data_json = load(data_path)
	chat = Chat.new(data_json.data.chat)
	sprite = Sprite2D.new()
	sprite.texture = load("res://icon.svg")
	
	shape = RectangleShape2D.new()
	shape.size = sprite.texture.get_size()
	colision = CollisionShape2D.new()
	colision.shape = shape
	
	input_pickable = true
	collision_layer = 2
	collision_mask = 1
	
func _enter_tree():
	add_child(chat)
	add_child(colision)
	add_child(sprite)
	gui = get_tree().get_nodes_in_group("gui")[0]
	interact_menu = preload("res://src/gui/interact_menu.tscn").instantiate()
	interact_menu.connect("button_down",Callable(self,"_interact_menu_button_down"))
	interact_menu.parent = self
	add_child(interact_menu)
	interact_menu.position = Vector2(0,0)
	interact_menu.position.y -= (10+interact_menu.size.y+shape.size.y/2)
	interact_menu.position.x -= (interact_menu.size.x/2)
	interact_menu.character_name.text = data_json.data.name
	
	
	chat.connect("response_received",Callable(self,"response_received"))
	chat.connect("finished_conversation",Callable(self,"finished_conversation"))

func finished_conversation(sender):
	save()
	pass

func response_received(content):
	pass
	
func _interact_menu_button_down(button):
	if button == "talk":
		gui.main_chat.connect_chat(chat)
		#interact_menu.visible = false



func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_released("ui_click"):
			interact_menu.visible = not interact_menu.visible

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if enable_motion:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func save():
	ResourceSaver.save(data_json,"res://src/data/characters/save/"+ data_json.data.name+".json")
	
	

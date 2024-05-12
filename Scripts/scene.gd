extends Node2D

@export var player : Node2D
var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")

# UI 
@onready var pause_menu_control := $UI/Control/Menu_Panel
@onready var shop_menu_control := $UI/Control/Shop_Panel
@onready var debug = $UI/Control/Debug

# Background 
@onready var background_parallax_layer = $Background/ParallaxBackground/ParallaxLayer
@onready var background_sprite_texture = $Background/ParallaxBackground/ParallaxLayer/Sprite2D

var source_id = 0
var water_atlas = Vector2i(0,1)
var land_atlas = Vector2i(0,2)

func _instantiate_shop():
	var initial_cost = 10
	var health_item_dict = {
		"MODIFIER_NAME":"HEALTH",
		"VALUE": player._get_health(),
		"COST": initial_cost,
		"UPGRADE": 10
		}
	
	var damage_item_dict = {
		"MODIFIER_NAME":"DAMAGE",
		"VALUE":player._get_damage(),
		"COST": initial_cost, 
		"UPGRADE": 5
		}
	
	var speed_item_dict = {
		"MODIFIER_NAME":"SPEED",
		"VALUE":player._get_speed(),
		"COST": initial_cost, 
		"UPGRADE": 10
		}
	
	var attackSpeed_item_dict = {
		"MODIFIER_NAME":"ATTACK SPEED",
		"VALUE" : player._get_attackSpeed(),
		"COST": initial_cost, 
		"UPGRADE": 0.1
		}
	
	var items = [health_item_dict, damage_item_dict, speed_item_dict, attackSpeed_item_dict]
	
	return items

func _ready():
	var screensize = DisplayServer.screen_get_size()
	background_sprite_texture.texture.width = screensize[0]*1.1
	background_sprite_texture.texture.height = screensize[1]*1.1
	background_parallax_layer.motion_mirroring.x = screensize[0]*1.1
	background_parallax_layer.motion_mirroring.y = screensize[1]*1.1 
	#Connect Signals
	player.connect("player_died",_on_player_dead)
	player.connect("player_damaged", _on_player_damaged)
	shop_menu_control.connect("shop_closed",_on_shop_closed)
	shop_menu_control.connect("item_bought",_on_item_buy)
	
	# Instantiations
	var items = _instantiate_shop()
	shop_menu_control._instantiate_shop(items)

func _process(delta):
	#generate_world(player.position)
	debug.text = "X: "+str(player.position.x)+"  Y: "+ str(player.position.y)
	
func _on_player_damaged():
	# Flash background to red. 
	print("damaged!")
	background_parallax_layer.modulate = Color('red')
	var tween = get_tree().create_tween()
	tween.tween_property(background_parallax_layer, "modulate", Color('white'), 0.4)
	
	

func _on_player_dead():
	print("dead")
	var tween = get_tree().create_tween()
	tween.tween_property(background_parallax_layer, "modulate", Color('black'), 1)
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	

# UI
func _on_pause_button_pressed():
	get_tree().paused =  true
	pause_menu_control.show()


func _on_play_button_pressed():
	print("Play")
	pause_menu_control.hide()
	get_tree().paused =  false

# SHOP
func _on_shop_button_pressed():
	# Open the Shop
	get_tree().paused =  true
	shop_menu_control.PLAYER_COINS = player._get_gold()
	shop_menu_control._update_shop()
	shop_menu_control.show()

func _on_shop_closed():
	get_tree().paused = false 
	shop_menu_control.hide()
	
func _on_item_buy(mod_name, value, coins):
	print("Item Bought")
	# update coins 
	player._set_gold(coins)
	shop_menu_control.PLAYER_COINS = player._get_gold()
	# update value 
	if mod_name == "HEALTH":
		player._set_health(value)
	elif mod_name == "DAMAGE":
		player._set_damage(value)
	elif mod_name == "SPEED":
		player._set_speed(value)
	elif mod_name == "ATTACK SPEED":
		player._set_attackSpeed(value)
		

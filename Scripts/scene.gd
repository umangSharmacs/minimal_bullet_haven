extends Node2D

@export var player : Node2D

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")

# UI 
@onready var pause_menu_control := $UI/Control/Menu_Panel
@onready var shop_menu_control := $UI/Control/Shop_Panel

# Background 
@export var noise_height_text : NoiseTexture2D
@onready var tilemap : TileMap = $Background_tileMap

var source_id = 0
var water_atlas = Vector2i(0,1)
var land_atlas = Vector2i(0,2)

var noise : Noise
var width : int = 1000
var height : int = 1000

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
	noise = noise_height_text.noise
	player.connect("player_died",_on_player_dead)
	shop_menu_control.connect("shop_closed",_on_shop_closed)
	shop_menu_control.connect("item_bought",_on_item_buy)
	var items = _instantiate_shop()
	shop_menu_control._instantiate_shop(items)
	#generate_world()
	
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_value = noise.get_noise_2d(x,y)
			if noise_value>0.0:
				tilemap.set_cell(-1,Vector2i(x,y), source_id,land_atlas)
			else:
				tilemap.set_cell(-1,Vector2i(x,y), source_id,water_atlas)


func _on_player_dead():
	print("dead")
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
		

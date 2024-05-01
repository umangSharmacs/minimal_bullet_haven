extends Node2D

@export var player : Node2D

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")

# Background 
@export var noise_height_text : NoiseTexture2D
@onready var tilemap : TileMap = $Background_tileMap

var source_id = 0
var water_atlas = Vector2i(0,1)
var land_atlas = Vector2i(0,2)

var noise : Noise
var width : int = 1000
var height : int = 1000

func _ready():
	noise = noise_height_text.noise
	#generate_world()
	
func generate_world():
	
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_value = noise.get_noise_2d(x,y)
			if noise_value>0.0:
				tilemap.set_cell(-1,Vector2i(x,y), source_id,land_atlas)
			else:
				tilemap.set_cell(-1,Vector2i(x,y), source_id,water_atlas)
		
func _on_enemy_died(body):
	print("Enemy Dead")
	body.queue_free()

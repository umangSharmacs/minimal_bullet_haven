extends Node

@export var player : CharacterBody2D
@export var Coins : Node2D
@export var max_enemy_limit : int = 10

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")
var coin_scene : PackedScene = load("res://Scenes/coin.tscn")

func _on_enemy_spawn_timer_timeout():
	if max_enemy_limit > get_child_count():
		var enemy = enemy_scene.instantiate()
		enemy.player = player
		add_child(enemy)
		enemy.connect("enemy_died",_kill_enemy)
		
func _kill_enemy(body):
	var coin = coin_scene.instantiate()
	coin.player = player
	coin.position.x = body.position.x
	coin.position.y = body.position.y
	body.queue_free()
	Coins.add_child(coin)

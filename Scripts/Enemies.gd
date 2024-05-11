extends Node

@export var player : CharacterBody2D
@export var Coins : Node2D
@export var max_enemy_limit : int = 10
@export var enemy_level : int = 1

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")
var coin_scene : PackedScene = load("res://Scenes/coin.tscn")

func _on_enemy_spawn_timer_timeout():
	if max_enemy_limit > get_child_count():
		var enemy = enemy_scene.instantiate()
		enemy.player = player
		var enemy_health = enemy._get_health()
		var enemy_speed = enemy._get_speed()
		var enemy_damage = enemy._get_damage()
		enemy_health = enemy_health + (enemy_level * 2)
		enemy_damage = enemy_damage + enemy_level
		enemy_speed = enemy_speed + (enemy_level * 0.1)
		enemy._set_health(enemy_health)
		enemy._set_speed(enemy_speed)
		enemy._set_damage(enemy_damage)
		add_child(enemy)
		enemy.connect("enemy_died",_kill_enemy)
		
func _kill_enemy(body):
	var coin = coin_scene.instantiate()
	coin.player = player
	coin.position.x = body.position.x
	coin.position.y = body.position.y
	body.queue_free()
	Coins.add_child(coin)


func _on_levelup_timer_timeout():
	#_level_up()
	pass # Replace with function body.
	
func _level_up():
	enemy_level += 1 
	max_enemy_limit += 5 
	# TODO - Play enemy levelling up animations here. Change their colour. 
	
	

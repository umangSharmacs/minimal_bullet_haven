extends Node

@export var player : CharacterBody2D
@export var Coins : Node2D
@export var max_enemy_limit : int = 10
@export var enemy_level : int = 1
@export var enemy_color : Color = Color.WHITE
@export var enemy_color_list = [Color.WHITE, Color.RED, Color.PURPLE, Color.GREEN, Color.AQUA, Color.CADET_BLUE, Color.CORAL, Color.CRIMSON, Color.DARK_BLUE, Color.DARK_ORCHID]
@onready var levelup_panel = $"../UI/Control/Enemy_LevelUp_Panel"

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")
var coin_scene : PackedScene = load("res://Scenes/coin.tscn")

func _on_enemy_spawn_timer_timeout():
	if max_enemy_limit > get_child_count():
		var enemy = enemy_scene.instantiate()
		enemy.player = player
		var enemy_health = enemy._get_health()
		var enemy_speed = enemy._get_speed()
		var enemy_damage = enemy._get_damage()
		var enemy_value = enemy._get_value()
		enemy_health = enemy_health + (enemy_level * 2)
		enemy_damage = enemy_damage + enemy_level
		enemy_speed = enemy_speed + (enemy_level * 0.1)
		enemy_value = enemy_value + (int(enemy_level/2) * 10)
		enemy._set_health(enemy_health)
		enemy._set_speed(enemy_speed)
		enemy._set_damage(enemy_damage)
		enemy._set_value(enemy_value)
		enemy.COLOR = enemy_color
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
	_level_up()
	$Levelup_Timer.start
	
func _level_up():
	print("Level Up")
	enemy_level += 1 
	max_enemy_limit += 5 
	enemy_color = enemy_color_list[(enemy_level-1)%len(enemy_color_list)]
	# TODO - Change their colour. 
	levelup_panel.modulate = Color.WHITE
	levelup_panel.show()
	var tween = get_tree().create_tween()
	tween.tween_property(levelup_panel, "modulate", Color.TRANSPARENT, 2.5)
	await get_tree().create_timer(2.5).timeout
	
	levelup_panel.hide()
	
	
	
	

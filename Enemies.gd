extends Node

@export var player : Node2D
@export var max_enemy_limit : int = 10

var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")

func _on_enemy_spawn_timer_timeout():
	if max_enemy_limit > get_child_count():
		var enemy = enemy_scene.instantiate()
		enemy.player = player
		add_child(enemy)

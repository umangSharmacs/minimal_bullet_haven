extends AnimatedSprite2D

var player : CharacterBody2D

@export var COIN_VALUE = 10

func _on_area_entered(area):
	var player = area.get_parent()
	player._set_gold(player.GOLD+COIN_VALUE)
	queue_free()

extends AnimatedSprite2D

var player : CharacterBody2D


func _on_area_entered(area):
	area.get_parent().GOLD+=10
	queue_free()

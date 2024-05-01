extends Area2D

@export var player : Node2D

func _on_body_entered(body):
	if body==player:
		print("+10!")
		queue_free()


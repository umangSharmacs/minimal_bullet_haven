extends Area2D

@export var SPEED: int = 1000
@export var DIRECTION = Vector2.RIGHT
@export var DAMAGE : int


func _physics_process(delta):
	position += DIRECTION * SPEED * delta
	

func _on_screen_exited():
	queue_free()
	
	
func _on_area_entered(area):
	if area.collision_layer==2:
		# delete the bullet 
		queue_free()
		# Reduce health of enemy
		area.HEALTH -= DAMAGE
	
	

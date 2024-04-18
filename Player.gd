extends CharacterBody2D


# Declaring values required
@export var HEALTH = 100
@export var SPEED = 300.0
@export var DAMAGE = 10
@export var LEVEL = 1
@export var SCORE = 0


# --------------------------- BULLETS --------------------------------------------
# Bullets timer.
#@onready var bullet_timer = $Bullet_Timer
#var ATTACK_SPEED = 1/bullet_timer.wait_time
# Load the bullets Scene
@export var bullet_scene : PackedScene = load("res://bullet.tscn")

# Get angle between Player and mouse position 
func get_direction():
	var mouse_pos = get_viewport().get_mouse_position()
	var direction = (mouse_pos-position).normalized()
	return direction
	
# Function to shoot based on the timer 
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.DAMAGE = DAMAGE
	bullet.position = position
	bullet.DIRECTION = get_direction()
	$Bullets.add_child(bullet)
	

func _on_bullet_timer_timeout():
	shoot()


# --------------------------- HEALTH CHECK --------------------------------------
func check_health():
	if HEALTH<0:
		get_tree().paused = true

func _process(delta):

	var direction = Input.get_vector("move_left", "move_right", "move_up","move_down")
	if direction:
		velocity.x = direction[0] * SPEED
		velocity.y = direction[1] * SPEED
		move_and_slide()
	
	check_health()
	





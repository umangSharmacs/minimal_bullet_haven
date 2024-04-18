extends CharacterBody2D

# Declaring values required
@export var HEALTH = 100
@export var SPEED = 300.0
@export var DAMAGE = 10
@export var LEVEL = 1
@export var SCORE = 0

@onready var enemies = get_parent().get_node("Enemies")
# --------------------------- BULLETS --------------------------------------------
# Bullets timer.
#@onready var bullet_timer = $Bullet_Timer
#var ATTACK_SPEED = 1/bullet_timer.wait_time
# Load the bullets Scene
@export var bullet_scene : PackedScene = load("res://bullet.tscn")

# Get angle between Player and mouse position 
func get_direction(closest_enemy):
	var direction = (closest_enemy.position-position).normalized()
	return direction

func get_closest_enemy():
	var closest_enemy
	var min_dist = INF
	for enemy in enemies.get_children():
		if min_dist>enemy.distance_from_player:
			min_dist = enemy.distance_from_player
			closest_enemy = enemy
	return closest_enemy
			

# Function to shoot based on the timer 
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.DAMAGE = DAMAGE
	bullet.position = position
	
	var closest_enemy = get_closest_enemy()
	bullet.DIRECTION = get_direction(closest_enemy)
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
	





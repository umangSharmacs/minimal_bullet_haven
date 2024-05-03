extends CharacterBody2D

# Declaring values required
@export var HEALTH = 100
@export var SPEED = 300.0
@export var DAMAGE = 10
@export var LEVEL = 1
@export var GOLD = 0

# SIGNALS
signal player_died 
signal level_up

@onready var enemies = get_parent().get_node("Enemies")

@export var MINIMUM_SHOOT_DISTANCE = 500

# UI  ELEMENTS
@onready var healthbar = $UI/HealthBar
@onready var coins_label = $UI/Coins_Label
# --------------------------- BULLETS --------------------------------------------
# Bullets timer.
#@onready var bullet_timer = $Bullet_Timer
#var ATTACK_SPEED = 1/bullet_timer.wait_time
# Load the bullets Scene
@export var bullet_scene : PackedScene = load("res://Scenes/bullet.tscn")

# Get angle between Player and mouse position 
func get_direction(closest_enemy):
	var direction = (closest_enemy.position-position).normalized()
	return direction

func get_closest_enemy():
	var closest_enemy
	var min_dist = MINIMUM_SHOOT_DISTANCE
	for enemy in enemies.get_children():
		if enemy is Area2D:
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
	if closest_enemy == null:
		return
		
	bullet.DIRECTION = get_direction(closest_enemy)
	$Bullets.add_child(bullet)
	

func _on_bullet_timer_timeout():
	#pass
	shoot()

# --------------------------- GOLD CHECK --------------------------------------
func _set_gold(new_gold):
	GOLD = new_gold
	coins_label.text = "COINS: "+str(GOLD)

# --------------------------- HEALTH CHECK --------------------------------------

func _set_health(new_health):
	HEALTH = new_health
	healthbar.health = HEALTH
	
func check_health():
	if HEALTH<0:
		player_died.emit()


# --------------------------- GAME LOOP --------------------------------------

func _ready():
	healthbar._init_health(HEALTH)
	
func _process(delta):

	var direction = Input.get_vector("move_left", "move_right", "move_up","move_down")
	if direction:
		velocity.x = direction[0] * SPEED
		velocity.y = direction[1] * SPEED
		move_and_slide()
	
	check_health()
	

# --------------------------- LEVEL UP LOGIC ----------------------------------

#func level_check():
	# Every 100 + (level*10) coins, the player will level up again. 
	
	

	

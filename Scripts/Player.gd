extends CharacterBody2D

# Declaring values required

@export var HEALTH = 100 : get = _get_health , set = _set_health
@export var SPEED = 300.0 : get = _get_speed , set = _set_speed
@export var DAMAGE = 10 : get = _get_damage , set = _set_damage 
@export var ATTACK_SPEED = 2 :  get = _get_attackSpeed , set = _set_attackSpeed
@export var LEVEL = 1 : get = _get_level , set = _set_level 
@export var GOLD = 0 : get = _get_gold , set = _set_gold 

@onready var bg_offset_x = 0.0
@onready var bg_offset_y = 0.0

# SIGNALS
signal player_died 
signal level_up
signal player_damaged

@onready var enemies = get_parent().get_node("Enemies")

@export var MINIMUM_SHOOT_DISTANCE = 500

# UI  ELEMENTS
@onready var healthbar = $UI/HealthBar
@onready var coins_label = $UI/Coins_Label
# --------------------------- BULLETS --------------------------------------------
# Bullets timer.
@onready var bullet_timer : Timer = $Bullet_Timer
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

# --------------------------- GOLD Setter Getter --------------------------------------
func _get_gold():
	return GOLD 

func _set_gold(new_gold):
	GOLD = new_gold
	# Update UI
	coins_label.text = "COINS: "+str(GOLD)

# --------------------------- HEALTH Setter Getter --------------------------------------

func _get_health():
	return HEALTH

func _set_health(new_health):
	new_health = clamp(new_health,0, INF)
	
	if new_health<HEALTH : 
		player_damaged.emit()
	
	HEALTH = new_health
	if healthbar:
		healthbar._set_health(HEALTH)
	
func check_health():
	if HEALTH<=0:
		player_died.emit()

# --------------------------- SPEED Setter Getter --------------------------------------

func _get_speed():
	return SPEED
	
func _set_speed(new_speed):
	SPEED = new_speed 
	

# --------------------------- DAMAGE Setter Getter --------------------------------------
func _get_damage():
	return DAMAGE

func _set_damage(new_damage):
	DAMAGE = new_damage 
	
# --------------------------- LEVEL Setter Getter --------------------------------------
	
func _get_level():
	return LEVEL 

func _set_level(new_level):
	LEVEL = new_level 

# --------------------------- ATTACK_SPEED Setter Getter --------------------------------------

func _get_attackSpeed():
	return ATTACK_SPEED

func _set_attackSpeed(new_attackSpeed):
	ATTACK_SPEED = new_attackSpeed
	bullet_timer.wait_time = 1.0/ATTACK_SPEED 

# --------------------------- GAME LOOP --------------------------------------

func _ready():
	
	var wait_time = 1/ATTACK_SPEED
	bullet_timer.wait_time = 1.0/ATTACK_SPEED 
	healthbar._init_health(HEALTH) 
	
func _process(delta):

	var direction = Input.get_vector("move_left", "move_right", "move_up","move_down")
	if direction:
		velocity.x = direction[0] * SPEED
		velocity.y = direction[1] * SPEED
		bg_offset_x += direction[0]
		bg_offset_y += direction[1]
		move_and_slide()
	
	check_health()
	

	

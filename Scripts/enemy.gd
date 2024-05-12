extends Area2D

@export var player : Node2D

@export var SPEED = 100 : get = _get_speed, set = _set_speed
@export var HEALTH = 20 : get = _get_health, set = _set_health
@export var DAMAGE = 10 : get = _get_damage, set = _set_damage
@export var CAN_DAMAGE : bool = true
@export var VALUE : int = 10 : get = _get_value, set = _set_value
@export var distance_from_player : float
@export var COLOR : Color

@onready var damage_numbers = $damage_numbers_component

signal enemy_died

var coin_scene : PackedScene = load("res://Scenes/coin.tscn")

var on_screen_bool : bool = false

# Getter Setters ----------------------------------------
# Speed
func _get_speed():
	return SPEED 
	
func _set_speed(new_speed):
	SPEED = new_speed
	
# HEALTH 
func _get_health():
	return HEALTH

func _set_health(new_health):
	# If player takes damage, set damage numbers 
	if new_health<HEALTH:
		damage_numbers.display_number(HEALTH-new_health, damage_numbers.position, false)
		
	HEALTH = new_health

# DAMAGE 
func _get_damage():
	return DAMAGE

func _set_damage(new_damage):
	DAMAGE = new_damage 

# VALUE 
func _get_value():
	return VALUE

func _set_value(new_value):
	VALUE = new_value


# GAME LOOP

func _ready():
	var screensize = DisplayServer.screen_get_size()
	var rng:= RandomNumberGenerator.new()
	
	var rand_x = rng.randi_range(0,screensize[1])
	var rand_y = rng.randi_range(0,screensize[0])
	
	var start_x = [0,screensize[0]]
	var start_y = [0,screensize[1]]
	
	var possible_pos_1 = [start_x[randi()%start_x.size()],rand_y]
	var possible_pos_2 = [rand_x, start_y[randi()%start_y.size()]]
	
	var possible_pos = [possible_pos_1, possible_pos_2]
	
	var position_list = possible_pos[randi()%possible_pos.size()]
	position = Vector2(position_list[0],position_list[1])
	
	modulate = COLOR

	
func _process(delta):
	var direction = (player.position - position).normalized()
	distance_from_player = (player.position - position).length()
	if direction:
		position.x += direction[0] * SPEED * delta
		position.y += direction[1] * SPEED * delta
		
		
	# If dead, remove from qeueue and spawn a coin
	if HEALTH<=0:
		enemy_died.emit(self)

		

func _on_can_damage_timer_timeout():
	CAN_DAMAGE = true
	
func _on_collision_with_player(body):
	if CAN_DAMAGE and body==player:
		CAN_DAMAGE = false
		player._set_health(player.HEALTH - DAMAGE)


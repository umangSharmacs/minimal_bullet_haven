extends ProgressBar

@onready var timer = $DamageBarTimer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health 
	health = min(max_value,new_health)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", health, 0.4)
	
	#value = health 
	
	if health < prev_health:
		timer.start()
	else: 
		# incase of healing 
		damage_bar.value = health 

func _init_health(_health):
	
	health = _health
	max_value = _health
	value = _health
	
	damage_bar.max_value = _health
	damage_bar.value = _health
	

func _on_damage_bar_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", health, 0.4)


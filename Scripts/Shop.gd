extends PanelContainer

var CURR_INDEX = 0 

@onready var coins_label = $Shop/Coins_Label
@onready var prev_button = $Shop/HBoxContainer/Prev_button
@onready var next_button = $Shop/HBoxContainer/Next_button
@onready var mod_label = $Shop/HBoxContainer/VBoxContainer/mod_name
#@onready var progress_bar = $Shop/HBoxContainer/VBoxContainer/ProgressBar
@onready var value_label = $Shop/HBoxContainer/VBoxContainer/Value_Label
@onready var cost_label = $Shop/HBoxContainer/VBoxContainer/Cost_Label
@onready var buy_button = $Shop/HBoxContainer/VBoxContainer/Buy_Button

var PLAYER_COINS: int

signal item_bought
signal shop_closed 

var shop_items

func _instantiate_shop(items):
	shop_items = items

	var cost = shop_items[CURR_INDEX]['COST']
	var value = shop_items[CURR_INDEX]['VALUE']
	var upgrade = shop_items[CURR_INDEX]['UPGRADE']
	
	mod_label.text = shop_items[CURR_INDEX]['MODIFIER_NAME']
	value_label.text = "VALUE: "+str(value)+"+"+str(upgrade)
	cost_label.text = "COST: "+str(cost)
	

func _update_shop():
	var cost = shop_items[CURR_INDEX]['COST']
	var value = shop_items[CURR_INDEX]['VALUE']
	var upgrade = shop_items[CURR_INDEX]['UPGRADE']
	
	coins_label.text = "Coins:  "+str(PLAYER_COINS)
	mod_label.text = shop_items[CURR_INDEX]['MODIFIER_NAME']
	cost_label.text = "COST: "+str(cost)
	value_label.text = "VALUE: "+str(value)+"+"+str(upgrade)
	
	if cost>PLAYER_COINS:
		buy_button.disabled = true
	else:
		buy_button.disabled = false

func _on_next_button_pressed():
	print(CURR_INDEX)
	if CURR_INDEX<len(shop_items)-1:
		CURR_INDEX +=1
	else:
		CURR_INDEX=0
	_update_shop()

func _on_prev_button_pressed():
	print(CURR_INDEX)
	if CURR_INDEX==0:
		CURR_INDEX = len(shop_items)-1
	else:
		CURR_INDEX -=  1
	_update_shop()


func _on_buy_button_pressed():
	
	var mod_name = shop_items[CURR_INDEX]['MODIFIER_NAME']
	var cost = shop_items[CURR_INDEX]['COST']
	var value = shop_items[CURR_INDEX]['VALUE']
	var upgrade = shop_items[CURR_INDEX]['UPGRADE']
	
	# Increase Cost 
	var updated_cost = (cost*2) + 10
	shop_items[CURR_INDEX]['COST'] = updated_cost
	
	# Increase current value 
	shop_items[CURR_INDEX]['VALUE'] = value+upgrade
	# Emit signal to actually increase player value and reduce player coins
	var updated_coins = PLAYER_COINS-cost
	
	item_bought.emit(mod_name, shop_items[CURR_INDEX]['VALUE'],updated_coins)
	
	# Update Shop 
	_update_shop()
	
func _on_close_button_pressed():
	shop_closed.emit()


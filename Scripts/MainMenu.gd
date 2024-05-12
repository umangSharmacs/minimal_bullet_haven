extends Control



func _on_play_button_pressed():
	print("Play")
	get_tree().change_scene_to_file("res://Scenes/scene.tscn")

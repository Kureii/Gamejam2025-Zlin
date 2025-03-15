extends Control


func _on_end_game_button_up() -> void:
	get_tree().quit()


func _on_start_game_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")


func _on_create_level_button_up() -> void:
	pass # Replace with function body.


func _on_hall_of_flame_button_up() -> void:
	var credits = get_tree().get_root().get_node("MainMenu/Aspect/Hall_of_flame")
	credits.visible = true


func _on_credits_button_up() -> void:
	var credits = get_tree().get_root().get_node("MainMenu/Aspect/Credits")
	credits.visible = true


func _on_hide_credits_button_up() -> void:
	var credits = get_tree().get_root().get_node("MainMenu/Aspect/Credits")
	credits.visible = false


func _on_hide_hall_of_flame_button_up() -> void:
	var credits = get_tree().get_root().get_node("MainMenu/Aspect/Hall_of_flame")
	credits.visible = false

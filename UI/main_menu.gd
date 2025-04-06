extends Control


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/OptionsMenu.tscn")


func _on_instructions_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Instructions.tscn")

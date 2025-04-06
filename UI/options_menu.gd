extends Control


func _on_sound_slider_value_changed(value: float) -> void:
	AudioManger.change_sound_volumne(value/100)


func _on_music_slider_value_changed(value: float) -> void:
	AudioManger.change_music_volume(value/100)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

extends Control

@onready var SoundSlider = $GridContainer/SoundSlider
@onready var MusicSlider = $GridContainer/MusicSlider

func _on_sound_slider_value_changed(value: float) -> void:
	AudioManger.change_sound_volumne(value)


func _on_music_slider_value_changed(value: float) -> void:
	AudioManger.change_music_volume(value)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://bjqi2kveqdgok")
	

func _ready() -> void:
	SoundSlider.value = AudioManger.sound_volumn
	MusicSlider.value = AudioManger.music_node.volume_linear

extends Node

class_name audio_manager

var music_node: AudioStreamPlayer
var sound_volumn:float = 1
func _ready() -> void:
	music_node = AudioStreamPlayer.new()
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_node)
	music_node.autoplay = true
	var stream: AudioStreamWAV = load("res://sounds/testdepth.wav")
	stream.loop_end = 1992978
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	music_node.stream = stream
	music_node.play()

func change_music_volume(volume: float):
	music_node.volume_linear = volume

func change_sound_volumne(volume: float):
	sound_volumn = volume

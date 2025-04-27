extends Node

class_name audio_manager

var music_node: AudioStreamPlayer
var sound_volumn:float = 1

var cnf_path:= "user://settings.ini"
var MUSIC_VAR := "MUSIC_VOLUME"
var SOUND_VAR := "SOUND_VOLUME"
var SOUND_SECTION := "SOUND_SETTINGS"

func _ready() -> void:
	music_node = AudioStreamPlayer.new()
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_node)
	music_node.autoplay = true
	var stream: AudioStreamWAV = load("uid://56uitvjv1gry")
	stream.loop_end = 1992978
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	music_node.stream = stream
	music_node.play()
	load_settings()

func change_music_volume(volume: float):
	music_node.volume_linear = volume
	record_settings()

func change_sound_volumne(volume: float):
	sound_volumn = volume
	record_settings()

func record_settings():
	var conf := ConfigFile.new()
	conf.set_value(SOUND_SECTION, SOUND_VAR, sound_volumn)
	conf.set_value(SOUND_SECTION, MUSIC_VAR, music_node.volume_linear)
	var error := conf.save(cnf_path)

func load_settings():
	var conf := ConfigFile.new()
	
	var error := conf.load(cnf_path)
	if error==OK:
		sound_volumn = conf.get_value(SOUND_SECTION, SOUND_VAR,1)
		music_node.volume_linear =  conf.get_value(SOUND_SECTION, MUSIC_VAR, 1)

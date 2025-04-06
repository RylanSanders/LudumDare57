extends Node2D

class_name game_controller

@export var death_menu:PackedScene
@export var pause_menu:PackedScene
@onready var spear:Node2D = get_node("Spear")
@onready var depth_label:Label = get_node("CanvasLayer/DepthLabel")
@onready var high_score_label: Label = get_node("CanvasLayer/HighScoreLabel")
@onready var gold_label: Label = get_node("CanvasLayer/GoldLabel")

var DEPTH_LABEL := "DEPTH: "
var HIGH_SCORE_LABEL := "HIGH SCORE: "
var HIGH_SCORE_VAR := "high_score"
var SCORES_SECTION_VAR := "scores"
var GOLD_VAR := "gold"
var GOLD_SECTION_VAR := "currency"
var cnf_path:= "user://scores.ini"
var current_high_score:=0.0
var last_high_score:=0.0
var current_gold := 0

var last_pause_menu: PopupMenu

func game_over():
	get_tree().paused=true
	var new_death_menu :PopupMenu = death_menu.instantiate()
	record_high_score()
	record_gold()
	new_death_menu.GameController=self
	add_child(new_death_menu)
	
	new_death_menu.popup_centered()

func record_high_score() -> void:
	var new_score = calculate_depth()
	if current_high_score > last_high_score:
		var conf := ConfigFile.new()
		conf.set_value(SCORES_SECTION_VAR,HIGH_SCORE_VAR, current_high_score)
		var error := conf.save(cnf_path)

func record_gold() -> void:
	var conf := ConfigFile.new()
	conf.set_value(GOLD_SECTION_VAR,GOLD_VAR, current_gold)
	var error := conf.save(cnf_path)

func _ready() -> void:
	get_saved_high_score()
	get_saved_gold()

func get_saved_high_score():
	var conf := ConfigFile.new()
	
	var error := conf.load(cnf_path)
	if error==OK:
		last_high_score = conf.get_value(SCORES_SECTION_VAR,HIGH_SCORE_VAR,0  )
		current_high_score = last_high_score
		high_score_label.text = HIGH_SCORE_LABEL + str(current_high_score)

func get_saved_gold():
	var conf := ConfigFile.new()
	
	var error := conf.load(cnf_path)
	if error==OK:
		var saved_gold = conf.get_value(GOLD_SECTION_VAR,GOLD_VAR,0  )
		current_gold = saved_gold
		gold_label.text =  str(saved_gold)

func retry()  -> void:
	get_tree().paused=false
	get_tree().reload_current_scene()
	
	

func main_menu()  -> void:
	record_gold()
	get_tree().paused=false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _process(delta: float) -> void:
	var depth = calculate_depth()
	depth_label.text = DEPTH_LABEL + str(depth)
	if depth>current_high_score:
		current_high_score = depth
	

func calculate_depth() -> float:
	return snappedf(spear.global_position.y, 0.01)

func resume() -> void:
	last_pause_menu.queue_free()
	get_tree().paused=false

func _on_pause_button_pressed() -> void:
	get_tree().paused=true
	last_pause_menu = pause_menu.instantiate()
	last_pause_menu.GameController=self
	add_child(last_pause_menu)
	
	last_pause_menu.popup_centered()
	
func add_gold(num: int):
	current_gold += num
	if gold_label != null:
		gold_label.text = str(current_gold)

func remove_gold(num:int):
	current_gold -= num
	gold_label.text = str(current_gold)


func _on_magic_button_pressed() -> void:
	pass # Replace with function body.

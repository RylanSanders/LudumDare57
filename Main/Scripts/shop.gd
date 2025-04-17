extends Node2D

class_name shop
var UPGRADES_SECTION := "upgrades"
var LAUNCH_VAR := "launch"
var WEIGHT_VAR := "weight"
var MAGIC_VAR := "magic"
var cnf_path:= "user://upgrades.ini"

@onready var GameController:game_controller = get_node("..")

var launch := 0
var launch_cost := 6
var weight := 0
var weight_cost := 4
var magic := 0
var magic_cost := 5
@onready var LaunchVal: Label = get_node("Launch/LaunchValLabel")
@onready var WeightVal: Label = get_node("Weight/WeightValLabel")
@onready var MagicVal: Label = get_node("Magic/MagicValLabel")

func record_upgrade_var() -> void:
	var conf := ConfigFile.new()
	conf.set_value(UPGRADES_SECTION,LAUNCH_VAR, launch)
	conf.set_value(UPGRADES_SECTION,WEIGHT_VAR, weight)
	conf.set_value(UPGRADES_SECTION,MAGIC_VAR, magic)
	var error := conf.save(cnf_path)

func reset():
	launch = 0
	magic = 0
	weight = 0
	record_upgrade_var()

func load_values():
	var conf := ConfigFile.new()
	
	var error := conf.load(cnf_path)
	if error==OK:
		launch = conf.get_value(UPGRADES_SECTION,LAUNCH_VAR,0)
		LaunchVal.text = str(launch)
		weight = conf.get_value(UPGRADES_SECTION,WEIGHT_VAR,0)
		WeightVal.text = str(weight)
		magic = conf.get_value(UPGRADES_SECTION,MAGIC_VAR,0)
		MagicVal.text = str(magic)

func _ready() -> void:
	load_values()


func _on_launch_strength_button_pressed() -> void:
	if GameController.current_gold >= launch_cost:
		launch+=1
		LaunchVal.text = str(launch)
		GameController.remove_gold(launch_cost)
		record_upgrade_var()


func _on_weight_button_pressed() -> void:
	if GameController.current_gold >= weight_cost:
		weight+=1
		WeightVal.text = str(weight)
		GameController.remove_gold(weight_cost)
		record_upgrade_var()


func _on_magic_button_pressed() -> void:
	if GameController.current_gold >= magic_cost:
		magic+=1
		MagicVal.text = str(magic)
		GameController.remove_gold(magic_cost)
		record_upgrade_var()

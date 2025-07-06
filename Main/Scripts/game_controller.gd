extends Node2D

class_name game_controller


@export var death_menu:PackedScene
@export var out_of_bounds_death_menu:PackedScene
@export var pause_menu:PackedScene
@export var show_num_objs: bool = false
@onready var spear:Node2D = get_node("Spear")
@onready var depth_label:Label = get_node("HUD/DepthLabel")
@onready var high_score_label: Label = get_node("HUD/HighScoreLabel")
@onready var gold_label: Label = get_node("HUD/GoldLabel")
@onready var num_objs_label:Label = get_node("HUD/NumObjectsLabel")

var DEPTH_LABEL := "DEPTH: "
var HIGH_SCORE_LABEL := "HIGH SCORE: "
var HIGH_SCORE_VAR := "high_score"
var SCORES_SECTION_VAR := "scores"
const GOLD_VAR := "gold"
const GOLD_SECTION_VAR := "currency"
const cnf_path:= "user://scores.ini"
var current_high_score:=0.0
var last_high_score:=0.0
var current_gold := 0

var show_objs_timer :=0.0
var SHOW_OBJS_REFRESH_RATE = 2

const INVENTORY_SAVE_FILE_PATH := "user://inventory.json"

var last_pause_menu: PopupMenu

var items_dict: Dictionary = {}



func game_over():
	save_inventory()
	get_tree().paused=true
	var new_death_menu :CanvasLayer = death_menu.instantiate()
	record_high_score()
	new_death_menu.GameController=self
	add_child(new_death_menu)
	new_death_menu.show()

func out_of_bounds():
	get_tree().paused=true
	var new_death_menu :CanvasLayer = out_of_bounds_death_menu.instantiate()
	record_high_score()
	new_death_menu.GameController=self
	add_child(new_death_menu)

func record_high_score() -> void:
	var new_score = calculate_depth()
	
	var conf := ConfigFile.new()
	if current_high_score > last_high_score:
		conf.set_value(SCORES_SECTION_VAR,HIGH_SCORE_VAR, current_high_score)
	conf.set_value(GOLD_SECTION_VAR,GOLD_VAR, current_gold)
	var error := conf.save(cnf_path)


func _ready() -> void:
	get_saved_high_score()
	get_saved_gold()
	load_inventory()
	
	if not show_num_objs:
		num_objs_label.queue_free()

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
	record_high_score()
	get_tree().paused=false
	get_tree().change_scene_to_file("uid://bjqi2kveqdgok")

func _process(delta: float) -> void:
	var depth = calculate_depth()
	depth_label.text = DEPTH_LABEL + str(depth)
	if depth>current_high_score:
		current_high_score = depth
	if show_num_objs:
		show_objs_timer += delta
		if show_objs_timer> SHOW_OBJS_REFRESH_RATE:
			show_objs_timer=0
			num_objs_label.text = "Num Objects: " + str(rec_count_nodes(get_tree().root))

func rec_count_nodes(node: Node)->int:
	var sum:=1
	for child in node.get_children():
		sum+=rec_count_nodes(child)
	return sum

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

func add_item(type: item_factory.ITEM_TYPE):
	if items_dict.get(type) == null:
		items_dict[type] = 1
	else:
		items_dict[type] += 1

func remove_gold(num:int):
	current_gold -= num
	gold_label.text = str(current_gold)

func save_inventory():
	var file := FileAccess.open(INVENTORY_SAVE_FILE_PATH, FileAccess.WRITE)
	var inventory_string = JSON.stringify(items_dict)
	file.store_string(inventory_string)

func load_inventory():
	var file := FileAccess.open(INVENTORY_SAVE_FILE_PATH, FileAccess.READ)
	if file != null:
		var parsedText = JSON.parse_string(file.get_as_text())
		if parsedText !=null:
			for k in parsedText.keys():
				items_dict[k as item_factory.ITEM_TYPE] = int(parsedText[k])
			


func _on_town_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://dx288na7ta4ga")

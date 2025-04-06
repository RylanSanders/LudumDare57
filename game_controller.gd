extends Node2D

@export var death_menu:PackedScene
@onready var spear:Node2D = get_node("Spear")
@onready var depth_label:Label = get_node("CanvasLayer/DepthLabel")

var DEPTH_LABEL := "DEPTH: "
func game_over():
	get_tree().paused=true
	var new_death_menu :PopupMenu = death_menu.instantiate()
	new_death_menu.GameController=self
	add_child(new_death_menu)
	
	new_death_menu.popup_centered()

func retry():
	get_tree().paused=false
	get_tree().reload_current_scene()
	
	

func main_menu():
	get_tree().paused=false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _process(delta: float) -> void:
	depth_label.text = DEPTH_LABEL + str(snappedf(spear.global_position.y, 0.01))

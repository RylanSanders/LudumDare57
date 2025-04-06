extends Node2D

@export var death_menu:PackedScene
@onready var spear_forward:Node2D = get_node("Spear/Forward")
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

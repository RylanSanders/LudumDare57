extends Node2D

var MAP_SECTION_HEIGHT := 544
var MAP_SECTION_DIST_TO_GENERATE := 3

var newMapPosition := 544

@export var map_section_1:PackedScene
@onready var spear: RigidBody2D = get_node("../Spear")

func _process(delta: float) -> void:
	if spear.global_position.y>newMapPosition-(MAP_SECTION_HEIGHT*MAP_SECTION_DIST_TO_GENERATE):
		generate_map_section()

func generate_map_section():
	var d:Node2D = map_section_1.instantiate()
	d.position.y = newMapPosition
	newMapPosition += MAP_SECTION_HEIGHT
	add_child(d)

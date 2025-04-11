extends Node2D

var MAP_SECTION_HEIGHT := 544
var MAP_SECTION_DIST_TO_GENERATE := 3

var MAP_SECTIONS_TO_KEEP_LOADED := 10
var old_map_sections_checker_timer := 0.0
var OLD_MAP_SECTIONS_CHECKER_TIME := 4.0

var newMapPosition := 544

@export var map_section_1:PackedScene
@onready var spear: RigidBody2D = get_node("../Spear")

func _process(delta: float) -> void:
	if spear.global_position.y>newMapPosition-(MAP_SECTION_HEIGHT*MAP_SECTION_DIST_TO_GENERATE):
		generate_map_section()
	old_map_sections_checker_timer += delta
	if old_map_sections_checker_timer>OLD_MAP_SECTIONS_CHECKER_TIME:
		old_map_sections_checker_timer =0
		for child in get_children():
			if child.global_position.y < spear.global_position.y - (MAP_SECTIONS_TO_KEEP_LOADED * MAP_SECTION_HEIGHT):
				child.queue_free()

func generate_map_section():
	var d:Node2D = map_section_1.instantiate()
	d.position.y = newMapPosition
	newMapPosition += MAP_SECTION_HEIGHT
	add_child(d)

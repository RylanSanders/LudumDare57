extends Node2D

var NUM_ROWS:=17
var ROW_HEIGHT:=32
var COL_WIDTH:=32
var NUM_COLUMN:=17

@export var fish_prob:float = 0.1
@export var plank_prob:float = 0.1
@export var seaweed_prob:float = 0.1
@export var rock_prob:float = 0.1

@export var fish_scn:PackedScene
@export var plank_scn:PackedScene
@export var seaweed_scn:PackedScene
@export var rock_scn:PackedScene

@export var rock_x_left: int = 0
@export var rock_x_right: int = 0

@onready var SpawnOffset:Node2D = get_node("SpawnOffset")
@onready var Map: TileMapLayer = get_node("TileMapLayer")

func _ready() -> void:
	for row in range(NUM_ROWS):
		if randf()<fish_prob:
			spawn_fish(row)
		if randf()<plank_prob:
			spawn_plank(row)
		if randf()<seaweed_prob:
			spawn_seaweed(row)
		if randf()<rock_prob:
			spawn_rock(row)
	spawn_walls()

func setup(passed_in_starting_y_val:int, passed_seed:float) -> void:
	starting_y_val = passed_in_starting_y_val * NUM_ROWS
	seed = passed_seed

var STARTING_RIGHT_GRID_POS := Vector2(8,-2)
var STARTING_LEFT_GRID_POS := Vector2(-10,-2)
var ATLAS_INDEX := 0
var WALL_INDEX :=Vector2(1,0)
var WALL_IN_GENERATION = 4
var starting_y_val :=0
var seed :=0
var LEFT_GEN_OFFSET = 3.2543
func spawn_walls():
	for i in range(NUM_ROWS):
		var y_val = STARTING_RIGHT_GRID_POS.y + i
		
		#Generate Right walls
		for r in range(WALL_IN_GENERATION):
			var wall_position = Vector2(STARTING_RIGHT_GRID_POS.x + calculate_wall_offset(y_val + STARTING_RIGHT_GRID_POS.y + starting_y_val) + r, y_val)
			Map.set_cell(wall_position, ATLAS_INDEX, WALL_INDEX)
		#Generate Left Walls
		for r in range(WALL_IN_GENERATION):
			var wall_position = Vector2(STARTING_LEFT_GRID_POS.x + calculate_wall_offset(y_val + STARTING_LEFT_GRID_POS.y + starting_y_val + LEFT_GEN_OFFSET) - r, y_val)
			Map.set_cell(wall_position, ATLAS_INDEX, WALL_INDEX)

func calculate_wall_offset(y_cord: int) -> int:
	var seeded_y_pos = seed + y_cord
	return (sin (0.1* seeded_y_pos) + sin(PI * seeded_y_pos * 0.04)) * 4.0

func spawn_rock(row: int):
	var d:Node2D = rock_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	if randf()>0.5:
		d.position.x = rock_x_left
	else:
		d.position.x = rock_x_right
		d.find_child("Sprite2D").flip_h = true
	
	add_child(d)

func spawn_fish(row: int):
	var d:Node2D = fish_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	var col = randi_range(1,NUM_COLUMN)
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

func spawn_seaweed(row: int):
	var d:Node2D = plank_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	var col = randi_range(1,NUM_COLUMN)
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

func spawn_plank(row: int):
	var d:Node2D = plank_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	var col = randi_range(1,NUM_COLUMN)
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

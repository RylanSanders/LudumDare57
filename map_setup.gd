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
	spawn_walls()

func setup(passed_in_starting_y_val:int, passed_seed:float) -> void:
	starting_y_val = passed_in_starting_y_val * NUM_ROWS
	#seed = passed_seed

var STARTING_RIGHT_GRID_POS := Vector2(8,-2)
var STARTING_LEFT_GRID_POS := Vector2(-10,-2)
var ATLAS_INDEX := 0
var WALL_INDEX :=Vector2(1,0)
var WALL_IN_GENERATION = 4
var starting_y_val :=0
var seed :=0
var LEFT_GEN_OFFSET = 334.2543
func spawn_walls():
	for i in range(NUM_ROWS):
		var y_val = STARTING_RIGHT_GRID_POS.y + i
		
		#Generate Right walls
		var right_wall_pos_x := STARTING_RIGHT_GRID_POS.x + calculate_wall_offset(y_val + STARTING_RIGHT_GRID_POS.y + starting_y_val)
		for r in range(WALL_IN_GENERATION):
			var map_pos = Vector2(right_wall_pos_x + r, y_val)
			Map.set_cell(map_pos, ATLAS_INDEX, WALL_INDEX)
		#Generate Left Walls
		var left_wall_pos_x := STARTING_LEFT_GRID_POS.x + calculate_wall_offset(y_val + STARTING_LEFT_GRID_POS.y + starting_y_val + LEFT_GEN_OFFSET)
		for r in range(WALL_IN_GENERATION):
			var wall_position = Vector2( left_wall_pos_x - r, y_val)
			Map.set_cell(wall_position, ATLAS_INDEX, WALL_INDEX)
		
		#if randf()<rock_prob/2:
				#spawn_rock(i,right_wall_pos_x+ 9, true)
		if randf()<rock_prob/2:
				spawn_rock(i,left_wall_pos_x+11, false)
		var num_cols = right_wall_pos_x-left_wall_pos_x
		for possible_x in range(left_wall_pos_x+1, right_wall_pos_x-1):
			if randf()<fish_prob/num_cols:
				spawn_fish(i,possible_x)
			if randf()<plank_prob/num_cols:
				spawn_plank(i,possible_x)
			if randf()<seaweed_prob/num_cols:
				spawn_seaweed(i,possible_x)
			#Move this one to just check the prob for hte outer edges
			
		

func calculate_wall_offset(y_cord: int) -> int:
	var seeded_y_pos = seed + y_cord
	return (sin (0.1* seeded_y_pos) + sin(PI * seeded_y_pos * 0.04)) * 4.0

func spawn_rock(row: int, col:int, is_left:bool):
	var d:Node2D = rock_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	d.position.x = col * COL_WIDTH + SpawnOffset.position.x
	if is_left:
		d.find_child("Sprite2D").flip_h = true
		
	
	add_child(d)

func spawn_fish(row: int, col:int):
	var d:Node2D = fish_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

func spawn_seaweed(row: int, col:int):
	var d:Node2D = plank_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

func spawn_plank(row: int, col:int):
	var d:Node2D = plank_scn.instantiate()
	d.position.y = row * ROW_HEIGHT + SpawnOffset.position.y
	d.position.x = (col+1) *COL_WIDTH + + SpawnOffset.position.x
	add_child(d)

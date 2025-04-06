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

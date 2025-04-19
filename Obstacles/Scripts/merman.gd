extends obstacle_base


@onready var spear: RigidBody2D = %Spear
@onready var arm: Sprite2D = $"Merman-arm"
@onready var trident_point: Node2D = $"Merman-arm-parent/Merman-arm/Trident-point"

@export var trident: PackedScene

var TRIDENT_SPAWN_TIME := 3.0
var trident_spawn_timer := 0.0
var TRIDENT_VEL := 200.0

var last_trident:Sprite2D = null


func spawn_trident() -> void:
	var new_trident = trident.instantiate()
	new_trident.global_position = trident_point.global_position
	get_parent().add_child(new_trident)
	last_trident = new_trident

func launch_trident() -> void:
	if last_trident != null:
		last_trident.launch((spear.global_position - global_position).normalized() * TRIDENT_VEL)
		last_trident = null

func _process(delta: float) -> void:
	if last_trident != null:
		last_trident.look_at(spear.global_position)

extends Line2D

@onready var SpearHandle:Node2D = get_node("../Spear/Handle")
@onready var Spear:Node2D = get_node("../Spear")
@export var random_offset:Vector2
func _process(delta: float) -> void:
	if Spear.is_angling_launch:
		points[0] = SpearHandle.global_position + random_offset

extends Area2D

var chest: Node2D
var SPEED := 300.0
var current_speed := SPEED
var ACCELERATION := 100.0

func _ready() -> void:
	var HUD = get_tree().get_first_node_in_group(item_factory.HUD_VAR)
	chest = HUD.get_node("Chest")

func _process(delta: float) -> void:
	current_speed += ACCELERATION * delta
	position = position.move_toward(chest.position, delta * current_speed)
	


func _on_area_entered(area: Area2D) -> void:
	queue_free()

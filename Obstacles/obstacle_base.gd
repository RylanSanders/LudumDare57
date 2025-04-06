extends Area2D

class_name obstacle_base
@export var durability:float = 10

func _on_obstacle_entered(area: Area2D) -> void:
	if area.name == "SpearTipArea":
		var params:obstacle_params  = obstacle_params.new()
		params.durability = durability
		area.get_parent().hit_obstacle(params)

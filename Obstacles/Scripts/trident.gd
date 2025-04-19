extends Sprite2D

var velocity: Vector2 = Vector2.ZERO
var is_launched := false


func _process(delta: float) -> void:
	if is_launched:
		position += velocity * delta

func launch(vel:Vector2) -> void:
	velocity = vel
	is_launched = true
	rotation = velocity.angle()

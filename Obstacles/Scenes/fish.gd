extends obstacle_base

var SPEED :=200
var is_going_right:=true

@onready var sprite:Sprite2D = get_node("Sprite2D")

func _process(delta: float) -> void:
	if is_going_right:
		position.x+=SPEED * delta
	else:
		position.x-=SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	is_going_right = not is_going_right
	sprite.flip_h= not is_going_right

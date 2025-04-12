extends obstacle_base

var SPEED :=200
var is_going_right:=true
var timer := 0.0
var VERTICAL_SPEED_MULTIPLIER :=3.0

@onready var sprite:Sprite2D = get_node("Sprite2D")

func _process(delta: float) -> void:
	if is_going_right:
		position.x+=SPEED * delta
	else:
		position.x-=SPEED * delta
	timer += delta * VERTICAL_SPEED_MULTIPLIER
	position.y += (sin(timer))
	

func _on_body_entered(body: Node2D) -> void:
	is_going_right = not is_going_right
	#Needed for if the sprite gets destroyed and it hits a wall
	if sprite != null:
		sprite.flip_h= not is_going_right

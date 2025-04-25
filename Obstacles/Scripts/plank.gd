extends obstacle_base


var timer:= 0.0
var amplitude := 0.2

func _ready() -> void:
	timer = randf()
func _process(delta: float) -> void:
	timer+=delta
	position.y += sin(timer) * amplitude

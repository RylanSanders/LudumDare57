extends TextureProgressBar


var barSpeed:= 50
var is_going_up:= true

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if is_going_up:
		value = move_toward(value, 100,barSpeed * delta)
		if value>=100:
			is_going_up = false
	else:
		value = move_toward(value, 0,barSpeed * delta)
		if value<=0:
			is_going_up = true
	

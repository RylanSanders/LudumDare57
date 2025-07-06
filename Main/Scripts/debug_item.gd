extends Button


func _on_pressed() -> void:
	ItemFactory.create_item($Node2D, "UNDEFINED")

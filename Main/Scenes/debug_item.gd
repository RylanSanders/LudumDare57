extends Button


func _on_pressed() -> void:
	ItemFactory.create_item($Node2D, item_factory.ITEM_TYPE.UNDEFINED)

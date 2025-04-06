extends Button

func _on_pressed() -> void:
	var root_node = get_tree().get_root()
	root_node.get_node("Main").get_node("MainMenu").queue_free()
	
	var new_scene_resource = load("res://Main.tscn")
	var new_scene_node = new_scene_resource.instantiate()
	root_node.add_child(new_scene_node) 

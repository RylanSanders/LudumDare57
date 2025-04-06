extends PopupMenu

var GameController



func _on_retry_button_pressed() -> void:
	GameController.retry()


func _on_main_menu_button_pressed() -> void:
	GameController.main_menu()

func _on_resume_button_pressed() -> void:
	GameController.resume()

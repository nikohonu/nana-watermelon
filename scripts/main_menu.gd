extends CenterContainer


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

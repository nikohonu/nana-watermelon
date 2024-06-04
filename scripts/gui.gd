extends CanvasLayer


@export var score_label: Label
@export var next_sprite: Sprite2D
@export var lost_timer_label: Label
@export var lost_popup: Control


func _on_game_score_changed(score: Variant) -> void:
	score_label.text = "Score: %s" % score


func _on_game_next_changed(next: int) -> void:
	next_sprite.texture = load("res://spirtes/yokai/yokai%s.png" % next)


func _on_game_lose_timer_changed(time_left: float) -> void:
	if time_left <= 5 and time_left != 0:
		lost_timer_label.set_text("%.2f" % time_left)
	else:
		lost_timer_label.set_text("")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_game_player_lost() -> void:
	lost_popup.show()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

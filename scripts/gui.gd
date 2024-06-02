extends CanvasLayer


@export var score_label: Label 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_score_changed(score: Variant) -> void:
	score_label.text = "Score: %s" % score
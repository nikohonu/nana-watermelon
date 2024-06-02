extends Node2D

signal score_changed(score)

@onready var circle_scene = preload("res://scenes/circle.tscn")

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_changed.emit(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event) -> void:
	if event is InputEventMouseButton && event.is_action_released("click"):
		var circle = circle_scene.instantiate()
		circle.position = Vector2(event.position.x, 80)
		circle.score_added.connect(_on_score_added)
		add_child(circle)

func _on_score_added(value):
	score += value
	score_changed.emit(score)

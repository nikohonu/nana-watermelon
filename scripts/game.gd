extends Node2D

@onready var circle_scene = preload("res://scenes/circle.tscn")

var a = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event) -> void:
	if event is InputEventMouseButton && event.is_action_released("click"):
		var circle = circle_scene.instantiate()
		circle.position = Vector2(event.position.x, 80)
		add_child(circle)

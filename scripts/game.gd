extends Node2D

signal score_changed(score)

const ELEMENT_START_Y = 80

@export var element_scene: PackedScene

var score = 0
var has_mouse = true
var current_element: Element = null


func check_mobile_phone():
	has_mouse = true
	match OS.get_name():
		"Android":
			has_mouse = false
		"iOS":
			has_mouse = false


func spawn_element():
	var element_start_x =  get_viewport_rect().size.x / 2
	if get_viewport().get_mouse_position().x != 0:
		element_start_x = get_viewport().get_mouse_position().x
	current_element = element_scene.instantiate()
	current_element.score_added.connect(_on_score_added)
	current_element.position = Vector2(element_start_x, ELEMENT_START_Y)
	add_child(current_element)


func _ready() -> void:
	check_mobile_phone()
	score_changed.emit(score)
	spawn_element()


func _process(delta: float) -> void:
	if Input.is_action_pressed("click") or has_mouse and current_element != null:
		current_element.position = Vector2(get_viewport().get_mouse_position().x, ELEMENT_START_Y)


func _input(event) -> void:
	if event is InputEventMouseButton && event.is_action_released("click"):
		current_element.position = Vector2(event.position.x, ELEMENT_START_Y)
		current_element.shadow = false
		current_element = null
		spawn_element()


func _on_score_added(value):
	score += value
	score_changed.emit(score)

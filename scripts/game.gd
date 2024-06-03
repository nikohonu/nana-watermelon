extends Node2D

signal score_changed(score)
signal next_changed(next)

const ELEMENT_START_Y = 96

var score = 0
var has_mouse = true
var current_yokai: Yokai = null
var next = 1:
	set(value):
		next = value
		next_changed.emit(next)


func check_mobile_phone():
	has_mouse = true
	match OS.get_name():
		"Android":
			has_mouse = false
		"iOS":
			has_mouse = false


func spawn_yokai(level: int, shadow = true, yokai_position = null):
	var yokai = Global.yokai_dict[level].instantiate()
	yokai.position = yokai_position
	yokai.score_added.connect(_on_score_added)
	yokai.collided.connect(_on_yokai_collided)
	yokai.shadow = shadow
	self.call_deferred("add_child", yokai)
	return yokai


func spawn_new_yokai():
	var element_start_x =  get_viewport_rect().size.x / 2
	if get_viewport().get_mouse_position().x != 0:
		element_start_x = get_viewport().get_mouse_position().x
	var yokai_position = Vector2(element_start_x, ELEMENT_START_Y)
	current_yokai = spawn_yokai(next, true, yokai_position)
	next = randi_range(1, 4)


func _ready() -> void:
	check_mobile_phone()
	score_changed.emit(score)
	next = randi_range(1, 4)
	spawn_new_yokai()


func _process(delta: float) -> void:
	if Input.is_action_pressed("click") or has_mouse and current_yokai != null:
		current_yokai.position = Vector2(get_viewport().get_mouse_position().x, ELEMENT_START_Y)


func _input(event) -> void:
	if event is InputEventMouseButton && event.is_action_released("click"):
		current_yokai.position = Vector2(event.position.x, ELEMENT_START_Y)
		current_yokai.shadow = false
		current_yokai = null
		spawn_new_yokai()


func _on_score_added(value):
	score += value
	score_changed.emit(score)


func _on_yokai_collided(yokai_position: Vector2, level: int):
	spawn_yokai(level, false, yokai_position)

extends Node2D

signal score_changed(score: int)
signal next_changed(next: int)
signal lose_timer_changed(time_left: float)
signal player_lost

const ELEMENT_START_Y = 96

@export var lose_timer: Timer

var body_out_of_cup = 0
var score = 0
var has_mouse = true
var current_yokai: Yokai = null
var game_stoped = false
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


func _process(_delta) -> void:
	if not game_stoped:
		if lose_timer.time_left > 0:
			lose_timer_changed.emit(lose_timer.time_left)
		if body_out_of_cup != 0 and not lose_timer.time_left > 0:
			lose_timer.start()
		if body_out_of_cup == 0:
			lose_timer.stop()
			lose_timer_changed.emit(lose_timer.time_left)
		if Input.is_action_pressed("click") or has_mouse and current_yokai != null:
			current_yokai.position = Vector2(get_viewport().get_mouse_position().x, ELEMENT_START_Y)


func _input(event) -> void:
	if not game_stoped:
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Yokai:
		body_out_of_cup += 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Yokai:
		body_out_of_cup -= 1


func _on_lose_timer_timeout() -> void:
	game_stoped = true
	player_lost.emit()

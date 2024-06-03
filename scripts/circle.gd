class_name Element
extends RigidBody2D


signal score_added(score_to_add: int)

const MAX_LEVEL = 12

@export var collision_shape2d: CollisionShape2D

var color = [
	Color("#1a1c2c"),
	Color("#5d275d"),
	Color("#b13e53"),
	Color("#ef7d57"),
	Color("#ffcd75"),
	Color("#a7f070"),
	Color("#38b764"),
	Color("#257179"),
	Color("#29366f"),
	Color("#3b5dc9"),
	Color("#41a6f6"),
	Color("#73eff7"),
	Color("#f4f4f4"),
	Color("#94b0c2"),
	Color("#566c86"),
	Color("#333c57"),
]
var radius = 8

var level = 1:
	get:
		return level
	set(value):
		radius = 8+((128-8)/15)*(value-1)
		value = clamp(value, 1, MAX_LEVEL)
		collision_shape2d.shape.radius = radius
		queue_redraw()
		level = value

var shadow:
	get:
		return shadow
	set(value):
		if value:
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, true)
			freeze = true
			queue_redraw()
		else:
			set_collision_layer_value(1, true)
			set_collision_layer_value(2, false)
			freeze = false
			queue_redraw()
		shadow = value


func _ready() -> void:
	shadow = true
	score_added.emit(self.level * 10)


func _draw() -> void:
	var element_color: Color = color[level - 1]
	if shadow:
		element_color.a = 0.5
	else:
		element_color.a = 1
	draw_circle(Vector2.ZERO, radius, element_color)


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is Element and not body.freeze:
		if body.level == self.level and level < MAX_LEVEL:
			position = position.lerp(body.position, 0.5)
			body.free()
			self.level += 1
			apply_central_impulse(Vector2(randi_range(-5, 5), -5))
			score_added.emit(self.level * 10)

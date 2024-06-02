class_name Circle
extends RigidBody2D

signal score_added(score_to_add: int)

const MAX_LEVEL = 12

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

@export var collision_shape2d: CollisionShape2D

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
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	score_added.emit(self.level * 10)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color[level - 1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is Circle:
		if body.level == self.level and level < MAX_LEVEL:
			position = position.lerp(body.position, 0.5)
			body.free()
			self.level += 1
			apply_central_impulse(Vector2(randi_range(-5, 5), -5))
			score_added.emit(self.level * 10)
	

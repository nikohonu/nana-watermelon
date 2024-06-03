class_name Yokai
extends RigidBody2D

signal score_added(score_to_add: int)
signal collided(position: Vector2, level: int)

const MAX_LEVEL = 5

@export var level: int
@export var sprite: Sprite2D
@export var score: int

var shadow:
	get:
		return shadow
	set(value):
		if value:
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, true)
			sprite.modulate.a = 0.5
		else:
			set_collision_layer_value(1, true)
			set_collision_layer_value(2, false)
			sprite.modulate.a = 1
			score_added.emit(self.score)
		self.freeze = value
		shadow = value


func _ready() -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is Yokai and not body.shadow:
		if body.level == self.level and self.level <  Global.yokai_dict.size():
			collided.emit(position.lerp(body.position, 0.5), level + 1)
			body.free()
			self.queue_free()

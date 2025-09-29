extends Area2D

@export var speed : int = 15
@export var damage: int = 10

var direction : Vector2
var TTL : int # Time To Live

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	_set_sprite_animation()
	


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	queue_free()

func _set_sprite_animation():
	# Flip sprite based on aiming direction, not movement direction.
	animated_sprite.rotation = direction.angle()

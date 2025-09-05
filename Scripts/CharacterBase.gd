extends CharacterBody2D
class_name CharacterBase

@export var sprite : AnimatedSprite2D
@export var speed : int
@export var direction : Vector2
@export var health : int
@export var healthBar : ProgressBar

var facingRight : bool = true
var invincible : bool = false
var alive : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	init_char()
	pass # Replace with function body.

func init_char():
	healthBar.max_value = health
	healthBar.value = health

func turn_sprite():
	if velocity.x > 0:
		facingRight = true
	elif velocity.x < 0:
		facingRight = false
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

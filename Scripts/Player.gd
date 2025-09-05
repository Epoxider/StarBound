extends CharacterBody2D

signal player_shot_bullet(bullet, rotation, position)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#const spellPath = preload("res://fire_bird_spell.tscn")
const Bullet = preload("res://Scenes/Bullet.tscn")

var SPEED : int = 300
var target_vec : Vector2
var destroyed : bool = false


func _process(_delta):
	$FiringPoint.look_at(get_global_mouse_position())
	if Input.is_action_pressed("attack1"):
		shoot()

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_get_input()
	
	_set_sprite_direction()

	move_and_slide()

func _set_sprite_direction():
	var atk_direction = ($FiringPoint.get_global_mouse_position() - $FiringPoint.global_position).normalized()

	if velocity.length() > 0:
		animated_sprite.play("move")
		if velocity.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")

	if Input.is_action_pressed("attack1"):
		animated_sprite.play("attack")
		if atk_direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	

func _get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_direction * SPEED

func shoot():
	var bullet_instance = Bullet.instantiate()
	var bullet_direction = ($FiringPoint.get_global_mouse_position() - $FiringPoint.global_position).normalized()
	player_shot_bullet.emit(bullet_instance, bullet_direction, $FiringPoint/Marker2D.global_position)

extends CharacterBody2D

signal player_shot_bullet(bullet, rotation, position)

#const spellPath = preload("res://fire_bird_spell.tscn")
const Bullet = preload("res://Scenes/Bullet.tscn")

var SPEED : int = 300
var target_vec : Vector2
var destroyed : bool = false


func _process(_delta):
	$FiringPoint.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("attack1"):
		shoot()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown").normalized()
	velocity = (direction * SPEED)

	move_and_slide()
	

func shoot():
	var bullet_instance = Bullet.instantiate()
	var bullet_direction = ($FiringPoint.get_global_mouse_position() - $FiringPoint/Marker2D.global_position).normalized()
	player_shot_bullet.emit(bullet_instance, bullet_direction, $FiringPoint/Marker2D.global_position)

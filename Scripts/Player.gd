extends CharacterBody2D

## Signal to be emitted when the player shoots a projectile.
signal player_died
signal player_shot_bullet(bullet_instance, rotation, position)

@export var max_health:int
@export var speed : int = 300


@onready var health:int = max_health
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var firing_point: Node2D = $FiringPoint
@onready var bullet_spawn_point: Marker2D = $FiringPoint/Marker2D

# Projectile resources.
const BULLET_SCENE = preload("res://Scenes/bullet.tscn")
const LIGHTNING_SCENE = preload("res://Scenes/lightning_spell.tscn")


func _process(_delta):
	# Make the firing point look at the mouse position for aiming.
	firing_point.look_at(get_global_mouse_position())
	
	# Handle shooting logic. This is best done in _process as it's not a physics action.
	if Input.is_action_pressed("attack1"):
		_shoot(BULLET_SCENE)
	if Input.is_action_pressed("attack2"):
		_shoot(LIGHTNING_SCENE)
		
	# Update the sprite animation based on player state.
	_set_sprite_animation()

func _physics_process(_delta):
	# Get the input direction for movement.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction.normalized() * speed
	
	# Apply the movement.
	move_and_slide()

## Helper function to handle shooting logic.
func _shoot(projectile_scene):
	var projectile_instance = projectile_scene.instantiate()
	var projectile_direction = (get_global_mouse_position() - firing_point.global_position).normalized()
	
	# Emit a signal to tell the main scene to spawn the projectile.
	player_shot_bullet.emit(projectile_instance, projectile_direction, bullet_spawn_point.global_position)

## Helper function to handle sprite animation.
func _set_sprite_animation():
	var aiming_direction = (firing_point.get_global_mouse_position() - firing_point.global_position).normalized()
	
	# Flip sprite based on aiming direction, not movement direction.
	if aiming_direction.x < 0:
		animated_sprite.flip_h = true
	elif aiming_direction.x > 0:
		animated_sprite.flip_h = false

	# Play the appropriate animation.
	if velocity.length() > 0:
		animated_sprite.play("move")
	elif Input.is_action_pressed("attack1"):
		animated_sprite.play("attack")
	else:
		animated_sprite.play("idle")
		
func take_damage(amount:int):
	health -= amount
	health = max(health, 0)
	print("Player took %d damage, health now %d" % [amount, health])
	if health <= 0:
		_die()

func _die():
	print("Player has died!")
	# TODO: death animation, respawn, etc.

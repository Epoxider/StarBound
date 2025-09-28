class_name base_enemy extends Area2D

signal died
signal attacked(amount)

@export var max_health:int = 100
@export var speed:int = 60
@export var attack_damage:int = 10
@export var attack_cooldown:float = 1.0
@export var aggro_radius:int = 120

enum State { IDLE, CHASE, ATTACK, DEAD }
var state: State = State.IDLE

@onready var spawn_point:Node2D = $SpawnPoint
@onready var health:int = max_health
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar:ProgressBar = $ProgressBar
@onready var body_collision:CollisionShape2D = $CollisionShape2D
@onready var aggro_area:Area2D = $AggroArea
@onready var attack_timer:Timer = $AttackTimer

var player:Node2D = null


func _ready():
	aggro_area.body_entered.connect(_on_body_entered)
	aggro_area.body_exited.connect(_on_body_exited)
	attack_timer.wait_time = attack_cooldown


func _process(delta:float) -> void:
	match state:
		State.IDLE:
			_set_sprite_animation("idle")
		State.CHASE:
			_chase_player(delta)
		State.ATTACK:
			attack_player()
		State.DEAD:
			pass


func _chase_player(delta:float) -> void:
	if not player: 
		state = State.IDLE
		return
	
	var direction = (player.global_position - global_position).normalized()
	position += direction * speed * delta
	_set_sprite_animation("walk")

	if global_position.distance_to(player.global_position) < 32:
		state = State.ATTACK


func attack_player() -> void:
	if attack_timer.is_stopped():
		# Will need to add new attack code for unique inherited enemies
		_set_sprite_animation("attack")
		emit_signal("attacked", attack_damage)
		attack_timer.start()


func take_damage(damage:int) -> void:
	health -= damage
	health = max(health, 0)
	_update_health_bar()

	if health <= 0 and state != State.DEAD:
		state = State.DEAD
		emit_signal("died")
		_die()


func _die() -> void:
	_set_sprite_animation("death")
	body_collision.disabled = true
	aggro_area.monitoring = false
	await sprite.animation_finished
	queue_free()


func _update_health_bar() -> void:
	health_bar.value = float(health) / float(max_health) * 100.0


func _set_sprite_animation(anim:String) -> void:
	if sprite.animation != anim:
		sprite.play(anim)
	if sprite.flip_h != (player and player.global_position.x < global_position.x):
		sprite.flip_h = not sprite.flip_h


# --- Signal Handlers ---
func _on_body_entered(body:Node) -> void:
	if body.is_in_group("player"):
		player = body
		state = State.CHASE

func _on_body_exited(body:Node) -> void:
	if body == player:
		player = null
		state = State.IDLE
		
func spawn_enemy() -> void:
	global_position = spawn_point.global_position

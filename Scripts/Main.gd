extends Node2D


@onready var bullet_manager = $BulletManager
@onready var player = $Player
@onready var beholder = $Beholder

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_shot_bullet.connect(_on_player_shoot)
	
	# for all enemies in scene, connect to their death signal
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died.bind(enemy))

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_shoot(bullet, direction, position):
	add_child(bullet)
	bullet.position = position
	bullet.direction = direction * bullet.speed
	
func _on_enemy_died(enemy_node):
	print("Enemy died:", enemy_node.name)
	enemy_node.queue_free()
	# Optional: spawn particles, play sound, update score
	#_spawn_death_effect(enemy_node.global_position)
	#_score += 100


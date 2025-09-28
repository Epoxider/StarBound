extends Node

# 	@onready var player = get_tree().get_first_node_in_group("player")
@onready var player = $"../PlayerParent/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_shot_bullet.connect(_on_player_shoot)
	
	# for all enemies in scene, connect to their death signal
	for enemy in get_tree().get_nodes_in_group("enemies"):
		print("found enemy")
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died.bind(enemy))

	pass # Replace with function body.
	
func connect_enemy_signals():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		print("found enemy")
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died.bind(enemy))

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


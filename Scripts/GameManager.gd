extends Node

@export var level1 : PackedScene

@onready var stage_parent: Node = get_parent().get_node("StageParent")
@onready var player: Node2D = get_parent().get_node("PlayerParent/Player")
@onready var camera: Camera2D = get_parent().get_node("Camera2D")


func _ready():
	player.player_shot_bullet.connect(_on_player_shoot)
	load_level(level1)

func _process(_delta):
	camera.global_position = player.global_position
	pass

func load_level(level_scene: PackedScene):
	# clear out the stage
	for child in stage_parent.get_children():
		child.queue_free()
	
	# instance the new level
	var level_instance = level_scene.instantiate()
	stage_parent.add_child(level_instance)

	#var current_level = level_instance
	
	await get_tree().process_frame
	
	# position player at spawn point
	var spawn_pt = level_instance.get_node_or_null("PlayerSpawnPt")
	if spawn_pt and player:
		player.global_position = spawn_pt.global_position
	
	# set up camera
	camera.make_current()
	# connect enemy signals
	_connect_enemy_signals()
	#camera.set_target(player)

func _connect_enemy_signals():
	# Connect to enemy spawner signal from current level
	var main_scene = stage_parent.get_child(0) 
	main_scene.enemy_spawned.connect(_on_enemy_spawn)
	# Connect to all pre loaded enemies in current level
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died.bind(enemy))


func _on_player_shoot(bullet, in_direction, in_position):
	stage_parent.add_child(bullet)
	bullet.position = in_position
	bullet.direction = in_direction * bullet.speed
	
func _on_enemy_died(enemy_node):
	enemy_node.queue_free()
	
func _on_enemy_spawn(enemy):
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))

extends Node2D

@export var level1 : PackedScene

@onready var stage_parent: Node = $StageParent
@onready var player_parent: Node = $PlayerParent
@onready var camera: Camera2D = $Camera2D
@onready var player: Node2D = player_parent.get_node("Player")

var current_level: Node = null

func _ready():
	load_level(level1)

func _process(delta):
	if player:
			camera.global_position = player.global_position
	pass

func load_level(level_scene: PackedScene):
	# clear out the stage
	for child in stage_parent.get_children():
		child.queue_free()
	
	# instance the new level
	var level_instance = level_scene.instantiate()
	stage_parent.add_child(level_instance)
	current_level = level_instance
	
	await get_tree().process_frame
	
	# position player at spawn point
	var spawn_pt = level_instance.get_node_or_null("PlayerSpawnPt")
	if spawn_pt and player:
		player.global_position = spawn_pt.global_position
	
	# set up camera
	camera.make_current()
	#camera.set_target(player)

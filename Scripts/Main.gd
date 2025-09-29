extends Node2D

signal enemy_spawned(enemy:CharacterBody2D)

@export var enemy: PackedScene
@export var spawn_time: int = 10
@onready var spawn_pt: Node2D = $EnemySpawnPt

func _ready():
	_spawn_enemy(spawn_time)

func _spawn_enemy(timer):
	for i in range(5):
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = spawn_pt.global_position
		enemy_instance.add_to_group("enemies")
		add_child(enemy_instance)
		emit_signal("enemy_spawned", enemy_instance)
		await get_tree().create_timer(timer).timeout


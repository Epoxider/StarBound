extends Node2D


@onready var bullet_manager = $BulletManager
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_node = get_node("Player")
	player_node.player_shot_bullet.connect(_on_player_shoot)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_shoot(bullet, direction, position):
	add_child(bullet)
	bullet.position = position
	bullet.velocity = direction * bullet.speed


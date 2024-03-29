extends Area2D

var speed : int = 1
var direction : Vector2
var TTL : int # Time To Live

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed
	

func removeSpell():
	queue_free()


func _on_body_entered(body):
	if not body is CharacterBody2D:
		print('collision deteteceted')
		removeSpell()


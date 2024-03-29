extends CharacterBody2D


#const spellPath = preload("res://fire_bird_spell.tscn")
const spellPath = preload("res://spell_base.tscn")

var SPEED : int = 300
var target_vec : Vector2
var destroyed : bool = false


func CastSpell():
	var spell = spellPath.instantiate()
	get_tree().current_scene.add_child(spell)
	#get_parent().add_child(spell)
	spell.position = $FiringPoint/Marker2D.global_position
	spell.direction = (get_global_mouse_position() - spell.position).normalized()

func _process(_delta):
	if Input.is_action_just_pressed("spell1"):
		CastSpell()
		
	$FiringPoint.look_at(get_global_mouse_position())

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown").normalized()
	velocity = (direction * SPEED)

	move_and_slide()

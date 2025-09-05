extends Node2D

func handle_bullet_spawned(bullet, direction, position):
	add_child(bullet)
	bullet.rotation = direction
	bullet.position = position
	bullet.velocity = bullet.velocity.rotated(direction)

extends RigidBody2D

@export var damage: int = 1

var Explosion: PackedScene = preload("res://projectiles/particles_explosion.tscn")

func _on_body_entered(body: Node):
	if !body.is_in_group("player"):
		var explosion = Explosion.instantiate()
		explosion.position = get_global_position()
		get_tree().get_root().add_child(explosion)
		queue_free()
		

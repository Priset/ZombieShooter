class_name power_ups
extends Area2D

func _ready() -> void:
	pass
	
func _on_timer_timeout():
	destroy_power_up()

func destroy_power_up() -> void:
	queue_free()

func apply_power_up(_body: Player) -> void:
	pass
	
func _on_body_entered(body):
	if body is Player:
		apply_power_up(body)
		destroy_power_up()

func _on_area_entered(_area):
	pass

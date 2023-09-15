extends Node
class_name Stats

signal no_health

@export var MAX_HP: int = 1 + HP_modifier()
@export var DAMAGE: int = 1
@export var CHASE_SPEED: float = 100

@onready var current_HP: int = MAX_HP:
	get:
		return current_HP
	set(value):
		current_HP = value
		if current_HP <= 0:
			emit_signal("no_health")

func _ready() -> void:
	var chase_multiplier = float("1.%s" % (Globals.wave_num-1))
	CHASE_SPEED *= chase_multiplier

func HP_modifier() -> int:
	return floor(clamp(Globals.wave_num/2, 0, Globals.wave_num/2))

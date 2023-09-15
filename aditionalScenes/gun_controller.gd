extends Node

@export var STARTING_WEAPON: PackedScene
@export var MAX_BULLETS: int = 350  # Establece el límite de balas
@onready var weapon_mount_point = get_parent().find_child("WeaponMountPoint")
var equipped_weapon: Node
@export var current_bullets: int = 350  # Variable para rastrear el número actual de balas

func _ready():
	if STARTING_WEAPON:
		equip_weapon(STARTING_WEAPON)

func equip_weapon(weapon_to_equip):
	if equipped_weapon:
		equipped_weapon.queue_free()
	else:
		equipped_weapon = weapon_to_equip.instantiate()
		weapon_mount_point.add_child(equipped_weapon)

func fire():
	if equipped_weapon and current_bullets > 0:
		current_bullets -= 1  # Resta una bala al disparar
		SignalBus.emit_signal("bullets_changed", current_bullets)
		equipped_weapon.fire()
		print(current_bullets)

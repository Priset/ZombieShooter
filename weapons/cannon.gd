extends Node2D

@export var BULLET: PackedScene
@export var BULLET_SPEED: float = 1000
@export var FIRE_DELAY: float = 0.12

@onready var muzzle: Marker2D = $muzzle
@onready var timer: Timer = $Timer

var can_fire: bool = true
var weapon_sfx: Array = [
	"res://assets/musicSfx/pistolShot.mp3",
	"res://assets/musicSfx/pistolShot2.mp3"
]

func _ready() -> void:
	timer.wait_time = FIRE_DELAY

func fire() -> void:
	if can_fire:
		var bullet = BULLET.instantiate()
		bullet.position = muzzle.global_position
		bullet.rotation_degrees = global_rotation_degrees
		bullet.transform = muzzle.global_transform
		bullet.linear_velocity = Vector2(BULLET_SPEED, 0).rotated(global_rotation)
		get_tree().get_root().call_deferred("add_child", bullet)
		AudioManager.play_sfx(Globals.random_sfx(weapon_sfx))
		can_fire = false
		timer.start()

func _on_timer_timeout() -> void:
	can_fire = true

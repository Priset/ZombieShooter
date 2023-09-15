extends CharacterBody2D
class_name Player

@export var ACCELERATION: float = 500
@export var MAX_SPEED: float = 275
@export var FRICTION: float = 500
@export var INVINCIBILITY_DELAY: float = 0.5
@export var MAX_HP: int = 100

@onready var weapon_mount_point: Marker2D = $WeaponMountPoint
@onready var gun_controller: Node = $GunController
@onready var stats: Stats = $Stats
@onready var collision_shape_2d = $CollisionShape2D
@onready var blink_animation_player = $BlinkAnimationPlayer


enum power_up {
	AMMUNITION
}

var explosion_sfx: Array = [
	"res://assets/musicSfx/deathPlayer",
	"res://assets/musicSfx/deathPlayer2",
	"res://assets/musicSfx/deathPlayer3"
]
var world_camera: Camera2D
var invincibility: bool = false

func _ready() -> void:
	stats.MAX_HP = MAX_HP  
	stats.current_HP = MAX_HP

func _physics_process(delta) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: 
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

	look_at(get_global_mouse_position())
		
	if Input.is_action_pressed("primary_action"):
		gun_controller.fire()
	
func apply_power_up(type: power_up) -> void:
	if type == power_up.AMMUNITION:
		if gun_controller:
			gun_controller.current_bullets += 200  # Recarga 100 balas al recolectar el power-up de munición
	else: 
		print("Unknown power-up")

# enemy collides with/damages player
func _on_area_2d_body_entered(body) -> void:
	if "enemy" in body.name:
		stats.current_HP -= 5  # Reduce la salud del jugador en 5 puntos cuando un enemigo colisiona
		if stats.current_HP <= 0:
			_on_stats_no_health()  # Si la salud llega a 0 o menos, llama a la función de derrota
		else:
			# Emite una señal para notificar el cambio de vida
			SignalBus.emit_signal("health_changed", stats.current_HP)
	elif "power_up" in body.name:
		# Recolecta el power-up y llama a la función para recargar balas
		var power_up_type = body.power_up_type  # Asume que el power-up tiene una variable "power_up_type" para identificarlo
		apply_power_up(power_up_type)
		body.queue_free()  # Elimina el power-up después de recolectarlo

func _on_stats_no_health():
	AudioManager.play_sfx(Globals.random_sfx(explosion_sfx))
	Globals.player_position = global_position
	SignalBus.emit_signal("game_over")
	print ("game over!")
	queue_free()

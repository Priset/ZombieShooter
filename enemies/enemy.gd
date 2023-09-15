extends CharacterBody2D
class_name Enemy

var Death_Animation: PackedScene = preload("res://enemies/death_animation.tscn")

@onready var movement_target_position: Vector2
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var stats: Stats = $Stats
@onready var attack_timer: Timer = $AttackTimer
@onready var gun_controller: Node = $GunController
@onready var polygon_2d = $Polygon2D
@onready var attack_light: PointLight2D = $AttackLight

enum state {
	SEEKING,
	ATTACKING,
	RETURNING,
	RESTING
}

var player: CharacterBody2D
var player_dead: bool = false

var attacking: bool = false
var current_state: state = state.SEEKING
var damage: int = -1 
var explosion_sfx: Array = [
	"res://assets/musicSfx/monsterDeath.mp3",
	"res://assets/musicSfx/monsterDeath2.mp3",
	"res://assets/musicSfx/monsterDeath3.mp3"
]
var splash_damage: int = 1
var can_splash_damage: bool = true
var splash_damage_delay: float = 0.25

func _ready() -> void:
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.try_again.connect(_on_start_game)
	
	call_deferred("actor_setup") 
	player = identify_player() 
		
	randomize()
	damage = stats.DAMAGE
	wave_modifier()
	
func _physics_process(_delta) -> void:
	if player != null: 
		movement_target_position = player.global_position
		
		match current_state:
			state.SEEKING:
				if nav_agent.is_target_reached() or not nav_agent.is_target_reachable():
					return
				
				var current_agent_position: Vector2 = global_position 
				var next_path_position: Vector2 = nav_agent.get_next_path_position()
				var new_velocity: Vector2 = next_path_position - current_agent_position
				
				new_velocity = new_velocity.normalized()
				new_velocity = new_velocity * stats.CHASE_SPEED
				velocity = new_velocity
				look_at(movement_target_position)
				move_and_slide()
			state.ATTACKING:
				move_and_attack()
			state.RETURNING:
				print("going back")
			state.RESTING:
				print("resting")
	else:
		player = identify_player() 

func actor_setup() -> void:
	await get_tree().physics_frame
	set_movement_target(movement_target_position)
	
func set_movement_target(movement_target: Vector2) -> void:
	nav_agent.target_position = movement_target

func move_and_attack() -> void:
	attack_timer.start()

func identify_player() -> CharacterBody2D:
	var first_player: CharacterBody2D
	var players: Array = get_tree().get_nodes_in_group("player")
	
	for alive_player in players:
		first_player = alive_player
		break
	
	return first_player
	
func self_destruct() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().call_group("enemy", "_on_stats_no_health")
	

func wave_modifier() -> void:
	var scale_multiplier = float("1.%s" % (Globals.wave_num-1))
	var colors = [
		Color(0.08,0.27,0.29,1),
		Color(0.06,0.25,0.41,1),
		Color(0.31,0.18,0.38,1),
		Color(0.41,0.14,0.19,1)
	]
	
func _on_area_2d_body_entered(body) -> void:
	if "bullet" in body.name:
		stats.current_HP -= body.damage
	elif body.is_in_group("player"):
		body.stats.current_HP -= 5 
		print("Jugador dañado, salud actual: ", body.stats.current_HP)
	
func _on_stats_no_health() -> void:
	var explosion = Death_Animation.instantiate()
	explosion.global_position = get_global_position()
	get_parent().call_deferred("add_child", explosion)
	queue_free()
	
	AudioManager.play_sfx(Globals.random_sfx(explosion_sfx))
	
	if not player_dead:
		SignalBus.emit_signal("update_score", 1)

func _on_attack_range_body_entered(_body) -> void:
	pass

func _on_path_update_timer_timeout() -> void:
	if player != null:
		set_movement_target(movement_target_position)

func _on_attack_timer_timeout() -> void:
	print("done")
	current_state = state.SEEKING

func _on_start_game() -> void:
	player_dead = false
	
func _on_game_over() -> void:
	player_dead = true
	self_destruct()

func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.is_in_group("splash_damage"):
		if can_splash_damage:
			stats.current_HP -= splash_damage
			can_splash_damage = false
			await get_tree().create_timer(splash_damage_delay).timeout
			can_splash_damage = true


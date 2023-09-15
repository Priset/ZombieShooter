extends Node2D

@onready var Player: PackedScene = preload("res://player/player.tscn")
@onready var player_spawn_point: Marker2D = $player/PlayerSpawnPoint
@onready var world_camera_node_path: NodePath = "/root/world/WorldCamera"

func _ready() -> void:
	SignalBus.emit_signal("start_game") 
	SignalBus.try_again.connect(_on_try_again) 
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_try_again() -> void:
	var players: Array = get_tree().get_nodes_in_group("player")
	for player in players:
		player.queue_free()
	var player: Player = Player.instantiate()
	player.global_position = player_spawn_point.global_position
	get_parent().get_node("world/player").add_child(player)
	get_tree().change_scene_to_file("res://world.tscn")
	# Reinicia el juego emitiendo la señal "start_game"
	SignalBus.emit_signal("start_game")


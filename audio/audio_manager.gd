extends Node

@onready var bgm: AudioStreamPlayer = $bgm
@onready var effect_player: Node = $effect_player

func _ready() -> void:
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.try_again.connect(_on_start_game)

	
	bgm.stream_paused = true
	
func play_music(music) -> void:
	bgm.stream = music
	bgm.play()
	
func play_sfx(clip) -> void:
	var n: int = effect_player.get_child_count()
	
	for i in range(n):
		var child: AudioStreamPlayer = effect_player.get_child(i)
		if !child.playing:
			child.stream = clip
			child.play()
			return

func stop_music() -> void:
	if bgm.playing:
		bgm.stream_paused = true

func _on_start_game() -> void:
	bgm.play()

func _on_game_over() -> void:
	stop_music()

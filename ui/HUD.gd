extends CanvasLayer

@onready var message = $Message
@onready var message_timer = $MessageTimer
@onready var message_game_over = $MessageGameOver
@onready var try_again_button = $TryAgainButton
@onready var score_num = $ScoreLabel/ScoreNum
@onready var high_score_num = $HighScoreLabel/HighScoreNum
@onready var wave_label = $WaveLabel
@onready var bullet_num = $BulletsLabel/BulletNum
@onready var hp_num = $HpLabel/HpNum

var message_original_position: Vector2

func _ready() -> void:
	SignalBus.update_score.connect(_on_update_score)
	SignalBus.update_wave.connect(_on_update_wave)
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.try_again.connect(_on_start_game)
	SignalBus.bullets_changed.connect(_on_bullets_changed)
	SignalBus.health_changed.connect(_on_health_changed)
	message_original_position = message.global_position
	update_high_score(Globals.high_score)
	
func show_message(text: String, fade_out: bool = true) -> void:
	message.global_position = message_original_position
	
	if fade_out:
		message_timer.start()
	
	message.text = text
	message.show()
	

func _on_update_score(points) -> void:
	Globals.score += points
	score_num.text = str(Globals.score)
		
	if Globals.score % 10 == 0:
		Globals.tween_pulsate(score_num)
	
	if Globals.score > Globals.high_score:
		update_high_score(Globals.score)

func update_high_score(points) -> void:
	Globals.high_score = points
	high_score_num.text = str(Globals.high_score)

func _on_update_wave(wave_num) -> void:
	Globals.tween_pulsate(wave_label)
	wave_label.text = "Wave "+str(wave_num)

# Agrega esta función para actualizar el número de balas en la UI
func _on_bullets_changed(current_bullets) -> void:
	Globals.current_bullets = current_bullets
	bullet_num.text = str(current_bullets)

func _on_health_changed(health) -> void:
	Globals.current_HP = health
	hp_num.text = str(health)

func _on_message_timer_timeout() -> void:
	Globals.tween_fade_out(message, 0.5, false)

func _on_try_again_button_pressed() -> void:
	try_again_button.hide()
	SignalBus.emit_signal("try_again")
	
func _on_start_game() -> void:
	Globals.score = 0
	SignalBus.emit_signal("update_score", 0)
	show_message("Get Ready")

func _on_game_over() -> void:
	message_game_over.text = "Game Over"
	message_game_over.show()
	try_again_button.show()

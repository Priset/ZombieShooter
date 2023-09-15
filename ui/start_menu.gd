extends ColorRect

@onready var start_button: Button = %StartButton
@onready var logo = $CenterContainer/Logo

var start_sfx: Array = [
	"res://assets/musicSfx/musicBox.mp3",
	"res://assets/musicSfx/musicBox.mp3"
]

func _ready() -> void:
	Globals.tween_fade_in(logo, 0.5)
	start_button.grab_focus()
	AudioManager.play_sfx(Globals.random_sfx(start_sfx))
	Globals.create_or_load_save()
	
func _on_start_button_pressed() -> void:
	LevelTransition.fade_from_black()
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

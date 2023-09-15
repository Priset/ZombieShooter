extends Node

var game_version: float = 0.8
var wave_num: int = 1
var score: int = 0
var high_score: int
var current_bullets: int
var current_HP: int
var player_position: Vector2 

var _save = SaveGame.new()

func tween_pulsate(node: Node) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE * 1.3, 0.1)
	tween.tween_property(node, "scale", Vector2.ONE, 0.5)

func tween_fade_out(node: Node, fade_out_time: float = 1.0, destroy: bool = true) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(node, "position", node.get_size() / 2, 0.5).as_relative()
	tween.tween_property(node, "modulate", Color(0, 0, 0, 0), fade_out_time)
	
	if destroy:
		tween.tween_callback(node.queue_free)
	else:
		pass
		
func tween_fade_in(node: Node, fade_in_time: float = 1.0) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(node, "modulate", Color(0, 0, 0, 0), 0)
	tween.tween_property(node, "modulate", Color(1, 1, 1, 1), fade_in_time)


func tween_appear(node: Node) -> void:
	node.show()
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(node, "modulate", Color(1,1,1,1), 0.1)
	tween.tween_property(node, "scale", Vector2.ONE * 1.3, 0.25)
	tween.tween_property(node, "scale", Vector2.ONE, 0.25)
	
func random_sfx(sfx: Array):
	return load(sfx[randi() % sfx.size()])

func create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_save_game()
	else:
		_save.write_save_game()
		
func save_game() -> void:
	_save.write_save_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()

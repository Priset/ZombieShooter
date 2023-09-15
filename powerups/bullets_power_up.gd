extends power_ups

func apply_power_up(body: Player) -> void:
	body.apply_power_up(body.power_up.AMMUNITION)

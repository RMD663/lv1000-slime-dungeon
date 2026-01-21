extends Area3D

func _ready() -> void:
	body_entered.connect(_body_entered)



func _body_entered(body : Player) -> void:
	Helper.get_game_ui()._play_fade_out()
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()

extends Marker3D
class_name PlayerSpawnPoint

var player : Player = null

func _ready() -> void:
	if not player:
		player = Helper.get_player()
	reset_player()
	Helper.reset.connect(_reset)

func _reset() -> void:
	reset_player()

func reset_player() -> void:
	player.global_position = self.global_position

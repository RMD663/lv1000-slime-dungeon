extends Node

@warning_ignore("unused_signal")
signal shake_camera(intensity : int, time : float)
@warning_ignore("unused_signal")
signal frame_freeze(freeze_time : float)
@warning_ignore("unused_signal")
signal next_scene(scene : PackedScene)
@warning_ignore("unused_signal")
signal reset
@warning_ignore("unused_signal")
signal entity_died
@warning_ignore("unused_signal")
signal pause
@warning_ignore("unused_signal")
signal fade_in
@warning_ignore("unused_signal")
signal fade_out
@warning_ignore("unused_signal")
signal start
@warning_ignore("unused_signal")
signal ended
@warning_ignore("unused_signal")
signal player_died

var max_combo : int = 0
var time_spent : String = ""

func _ready() -> void:
	ended.connect(_ended)
	frame_freeze.connect(_frame_freeze)

func _frame_freeze(timescale : float, freeze_time : float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(timescale * freeze_time).timeout
	Engine.time_scale = 1

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		pause.emit()
		print("Paused")
	
func get_player() -> Player:
	var player = get_tree().get_first_node_in_group("Player")
	return player

func get_camera() -> GameCamera:
	var camera = get_viewport().get_camera_3d()
	return camera

func get_game_ui() -> GameUI:
	return get_tree().get_first_node_in_group("GameUI")

func get_enemy_spanwer() -> Entities:
	return get_tree().get_first_node_in_group("Entities")

func random_pitch(min_pitch : float, max_pitch : float) -> float:
	return randf_range(min_pitch, max_pitch)

func _ended() -> void:
	fade_out.emit()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/end_game/end_game_screen.tscn")

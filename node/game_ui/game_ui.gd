extends Control
class_name GameUI

@export var game_over_ui : Control 
@export var resume_button : Button
@export var reset_button : Button
@export var quit_button : Button
@export var effects : AnimationPlayer
@export var enemies_left : Label
@export var combo_label : Label
@export var timer_label : TimeCounter

var first_start : bool = true

func _ready() -> void:
	combo_label.hide()
	enemies_left.hide()
	timer_label.hide()
	enemies_left.text = "ENEMIES LEFT\n" + str(Helper.get_enemy_spanwer().current_enemies)
	game_over_ui.visible = false
	Helper.entity_died.connect(_update_left)
	Helper.fade_in.connect(_play_fade_in)
	Helper.fade_out.connect(_play_fade_out)
	Helper.reset.connect(_play_reset)
	Helper.pause.connect(_pause_game)
	resume_button.pressed.connect(_resume_pressed)
	reset_button.pressed.connect(_reset_pressed)
	quit_button.pressed.connect(_quit_pressed)

func _resume_pressed() -> void:
	Helper.pause.emit()

func _reset_pressed() -> void:
	Helper.reset.emit()
	await get_tree().create_timer(0.1).timeout
	Helper.pause.emit()

func _quit_pressed() -> void:
	get_tree().quit()

func _pause_game() -> void:
	game_over_ui.visible = !game_over_ui.visible

func _play_fade_in() -> void:
	effects.play("fade_in")

func _play_fade_out() -> void:
	effects.play("fade_out")

func _play_reset() -> void:
	if not first_start:
		enemies_left.text = "ENEMIES LEFT\n" + str(250)
		effects.play("reset")
		combo_label.show()
		enemies_left.show()
		timer_label.show()
		await effects.animation_finished
		Helper.start.emit()
		timer_label.timer_on = true
	else:
		enemies_left.text = "ENEMIES LEFT\n" + str(250)
		enemies_left.hide()
		timer_label.show()
		combo_label.show()
		effects.play("fade_in")
		await effects.animation_finished
		enemies_left.show()
		Helper.start.emit()
		first_start = false

func _update_left() -> void:
	if Helper.get_enemy_spanwer().current_enemies:
		var current_enemies = Helper.get_enemy_spanwer().current_enemies
		enemies_left.text = "ENEMIES LEFT\n" + str(current_enemies)

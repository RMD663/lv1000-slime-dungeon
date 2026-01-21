extends Control
class_name EndGameScreen

const WORLD = preload("uid://dxwtyveqf58d4")

@onready var max_combo: Label = $CenterContainer/VBoxContainer/MaxCombo
@onready var time_spent: Label = $CenterContainer/VBoxContainer/TimeSpent
@onready var try_again: Button = $CenterContainer/VBoxContainer/TryAgain
@onready var quit: Button = $CenterContainer/VBoxContainer/Quit

func _ready() -> void:
	print(Helper.max_combo)
	max_combo.text = "MAX COMBO\n" + str(Helper.max_combo)
	time_spent.text = "TOTAL TIME\n" + str(Helper.time_spent)
	try_again.pressed.connect(_try_again_pressed)
	quit.pressed.connect(_quit_pressed)

func _try_again_pressed() -> void:
	get_tree().quit()

func _quit_pressed() -> void:
	get_tree().quit()

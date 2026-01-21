extends Label
class_name TimeCounter


var paused : bool = false
var time : float = 0
var timer_on : bool = false

func _ready() -> void:
	Helper.reset.connect(_reset)
	Helper.ended.connect(_ended)
func _process(delta: float) -> void:
	if not paused:
		if timer_on:
			time += delta
		
		var milsec : float = fmod(time, 1)*1000
		var secs : float = fmod(time, 60)
		var mins : float = fmod(time, 60*60) / 60 

		var time_passed : String = "%2d : %2d : %2d" % [mins, secs, milsec]
		text = time_passed
		Helper.time_spent = text

func _reset() -> void:
	time = 0
	timer_on = true

func _ended() -> void:
	paused = true
	Helper.time_spent = text

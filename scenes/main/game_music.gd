extends AudioStreamPlayer


@export var effects : AnimationPlayer

const ENDING : AudioStream = preload("uid://de5m3wjsgy4t1")
const LEVEL_1 : AudioStream = preload("uid://s8gcf8ja0a53")
const LEVEL_2 : AudioStream = preload("uid://bbfsxt5t2x2xo")
const LEVEL_3 : AudioStream = preload("uid://08j8yidllny5")
const TITLE_SCREEN : AudioStream = preload("uid://45rfdcqdhpo3")


var musics : Dictionary = {
	"Menu" : TITLE_SCREEN,
	"Ending" : ENDING,
	"Level" : LEVEL_1
	}

func play_music(music_name : String) -> void:
	var stream_to_play : AudioStream = musics.get(music_name)
	stream = stream_to_play
	play()

func reset_music() -> void:
	play(0.0)

extends Resource
class_name ScreenShakeData

@export var shake_intensity : float = 0.0
@export var active_shake_time : float = 0.0

var shake_decay: float

var noise = FastNoiseLite.new()

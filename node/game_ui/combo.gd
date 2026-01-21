extends Label
class_name ComboCounter

var combo : int = 0
@export var combo_timer : Timer
@export var shake_intensity : float = 0.0
@export var active_shake_time : float = 0.0
@export var parent : Control
var shake_decay: float
var shake_time : float = 0.0
var shake_time_speed : float = 20.0
var game_over : bool = false
var noise = FastNoiseLite.new()

func _ready() -> void:
	text = "COMBO: " + str(combo)
	combo_timer.timeout.connect(_combo_timeout)
	combo_timer.start()
	Helper.entity_died.connect(_entity_died)
	Helper.reset.connect(_reset)

func _physics_process(delta: float) -> void:
	shake(delta)
	if combo > 30 and combo < 50:
		apply_shake(1.5, 1.0) 
		self.modulate = Color.YELLOW
	elif combo > 50 and combo < 100:
		apply_shake(2.0, 1.0)
		self.modulate = Color.RED
	elif combo > 100:
		apply_shake(2.5, 1.0)
		self.modulate = Color.WEB_MAROON
	elif combo > 250:
		apply_shake(3.0, 1.0)
		self.modulate = Color.RED
	Helper.max_combo = combo if combo > Helper.max_combo else Helper.max_combo

func shake(delta : float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		parent.position.x = noise.get_noise_2d(shake_time, 0) * shake_intensity 
		parent.position.y = noise.get_noise_2d(0, shake_time) * shake_intensity 
		
		shake_intensity =  max(shake_intensity - shake_decay * delta, 0)
	else:
		parent.position.x = lerp(parent.position.x, 0.0, 10 * delta)
		parent.position.y = lerp(parent.position.y, 0.0, 10 * delta)

func apply_shake(intensity : float, time : float) -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

func update_combo_text() -> void:
	text = "COMBO: " + str(combo)
	apply_shake(2.0, 0.5)


func _entity_died() -> void:
	combo += 1
	combo_timer.start()
	update_combo_text()

func _reset() -> void:
	combo = 0
	update_combo_text()
	self.modulate = Color.WHITE

func _combo_timeout() -> void:
	if not game_over:
		Helper.max_combo = combo if combo > Helper.max_combo else Helper.max_combo
		combo = 0
		update_combo_text()

func _end() -> void:
	Helper.max_combo = combo if combo > Helper.max_combo else Helper.max_combo
	game_over = true

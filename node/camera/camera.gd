extends Camera3D
class_name GameCamera 

@export var speed : float = 2.0

@export var desired_h_offset : float = 3.0
@export var desired_v_offset : float = 2.0
@export var lock_v_movement : bool = false



@export var shake_intensity : float = 0.0
@export var active_shake_time : float = 0.0

var shake_decay: float
var shake_time : float = 0.0
var shake_time_speed : float = 20.0

var noise = FastNoiseLite.new()


var acceleration : float = 2.0
var target : Vector3 = Vector3.ZERO
var locked : bool = false

var player : Player = null

func _ready() -> void:
	Helper.shake_camera.connect(_shake_camera)
	get_player()
	
func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		h_offset = noise.get_noise_2d(shake_time, 0) * shake_intensity 
		v_offset = noise.get_noise_2d(0, shake_time) * shake_intensity 
		
		shake_intensity =  max(shake_intensity - shake_decay * delta, 0)
	else:
		h_offset = lerp(h_offset, 0.0, acceleration * delta)
		v_offset = lerp(v_offset, 0.0, acceleration * delta)
	if not locked:
		move(delta)
	else:
		self.global_position = target

func apply_offset() -> void:
	pass

func move(delta : float) -> void:
	global_position.x = player.global_position.x
	
	if not lock_v_movement:
		global_position.y = player.global_position.y

func get_player() -> void:
	player = Helper.get_player()

func _shake_camera(intensity : float, time : float) -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

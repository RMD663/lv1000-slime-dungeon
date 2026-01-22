extends CharacterBody3D
class_name Player


@export var hit_box : HitBox
@export var sprite : Sprite3D
@export var hurt_data : HurtData
@export var player_data : PlayerData
# Smooth Acceleration
@export var acceleration : float = 3.0
@export var friction : float = 3.0
@export var speed : float = 10.0
@export var knockback : float = 5.0
@export var pick_effect_timer : Timer
@export var body : Node3D

var is_dead : bool = false
var has_effect_active : bool = false
var can_move : bool = true
var can_be_hurt : bool = true
var direction : Vector2 = Vector2.ZERO
var health : int = 100

@onready var fsm : PlayerFiniteStateMachine = $FiniteStateMachine

func _ready() -> void:
	pick_effect_timer.timeout.connect(_pickup_timeout)
	Helper.reset.connect(_reset)
	Helper.pause.connect(_pause)
	Helper.ended.connect(_ended)

func _physics_process(_delta: float) -> void:
	if can_move:
		move_and_slide()

func _input(_event: InputEvent) -> void:
	get_player_input()
	#if Input.is_action_just_pressed("block"):
		#self.scale.x -= 1

func move(delta : float) -> void:
	var desired_movement_speed : Vector2 = direction * speed
	velocity.x = lerp(velocity.x, desired_movement_speed.x, acceleration * delta)
	velocity.z = lerp(velocity.z, desired_movement_speed.y, acceleration * delta)

func stop(delta : float) -> void:
	velocity.x = lerp(velocity.x, 0.0, friction * delta)
	velocity.z = lerp(velocity.z, 0.0, friction * delta)

func apply_gravity(delta : float) -> void:
	velocity.y += get_gravity().y * delta

func apply_knockback(force_direction : Vector3, force : float = 5.0) -> void:
	force_direction.y = force / 8
	velocity = force_direction * force
	
func get_player_input() -> void:
	if can_move:
		direction = Input.get_vector("left","right","up","down")
	
	body.scale.x = sign(direction.x) if direction.x != 0.0 else body.scale.x

func hurt(hurt_data : HurtData) -> void:
	if can_be_hurt:
		can_be_hurt = false
		Helper._frame_freeze(0.1, 0.2)
		apply_knockback(hurt_data.direction, hurt_data.knockback)
		health -= hurt_data.damage
		if health <= 0:
			fsm.next_state("Die")
		fsm.next_state("Hurt")

func apply_effect(data : EffectData) -> void:
	#if has_effect_active or is_dead:
		#return
	if not is_dead:
		has_effect_active = true
		var current_state : String = fsm.get_current_state()
		if current_state != "Idle" or current_state != "Move" and not current_state == "Die":
			fsm.next_state("Idle")
		health += data.health
		scale += data.scale
		scale = scale.clamp(Vector3(0.1, 0.1, 1), Vector3(10, 10, 1))
		speed += data.speed
		pick_effect_timer.start(data.duration)
		global_position.y += abs(data.scale.y) / 3


func player_is_moving() -> bool:
	return true if direction else false

func _pause() -> void:
	if process_mode == ProcessMode.PROCESS_MODE_ALWAYS:
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS

func _reset() -> void:
	is_dead = true
	direction = Vector2.ZERO
	velocity = Vector3.ZERO
	health = player_data.health
	can_be_hurt = true
	sprite.modulate = Color.WHITE
	sprite.rotation =  Vector3.ZERO
	await get_tree().create_timer(0.4).timeout
	fsm.next_state("Idle")
	await Helper.start
	can_move = true
	is_dead = false

func _pickup_timeout() -> void:
	has_effect_active = false
	health = player_data.health
	speed = player_data.speed
	knockback = player_data.knockback
	scale = player_data.scale

func _ended() -> void:
	can_be_hurt = false
	can_move = false
	

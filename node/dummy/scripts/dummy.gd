extends CharacterBody3D
class_name Enemy


@export var drops : Array[PackedScene]

@export var hurt_data : HurtData
@export var health : int = 5
@export var friction : float = 5.0
@export var state_label : Label3D
@export var body : Node3D
@export var sprite : Sprite3D
@export var knockback : float = 5.0
var can_be_hurt : bool = true
var spawn_position : Vector3
var player_alive : bool = true
var appearence : Array[int] = [0, 1, 2]
const gravity : float = 100
@onready var fly_sfx: AudioStreamPlayer = $Effects/FlySfx

@onready var fsm: EnemyFiniteStateMachine = $FSM

func spawn() -> void:
	pass

func _ready() -> void:
	global_position = spawn_position
	fly_sfx.pitch_scale = Helper.random_pitch(0.7, 1.5)
	Helper.player_died.connect(_player_is_dead)
	Helper.ended.connect(_ended)
	sprite.frame = appearence.pick_random()
	hurt_data.damage = randi_range(1, 5)
	hurt_data.knockback = randf_range(3.0, 9.0)
	var random_scale = randf_range(1.0, 1.3)
	scale = Vector3(random_scale, random_scale, 1)


func _process(_delta: float) -> void:
	rotate_body()

func apply_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func move(delta : float) -> void:
	velocity.x = lerp(velocity.x, 0.0, friction * delta)
	velocity.z = lerp(velocity.z, 0.0, friction * delta)

func rotate_body() -> void:
	body.scale.x = sign(velocity.x) if velocity.x != 0.0 else body.scale.x

func apply_knockback(direction : Vector3, force : float = 5.0) -> void:
	direction.y = force / 8
	velocity = direction * force

func hurt(hurt_data : HurtData) -> void:
	if can_be_hurt:
		apply_knockback(hurt_data.direction, hurt_data.knockback)
		health -= hurt_data.damage
		fsm.next_state(fsm.StateID.HURT)

func die() -> void:
	drop()
	queue_free.call_deferred()

func _die() -> void:
	queue_free.call_deferred()

func fly_away() -> void:
	var chance : int = 1
	var rand_chance : int = randi_range(0, 10)
	if rand_chance == chance:
		fly_sfx.play()
		apply_knockback(-body.scale.normalized(), 15)

func drop() -> void:
	var drop_chance : int = 1
	var rand_chance : int = randi_range(0, 5) 
	if rand_chance == drop_chance:
		var drop_node = drops.pick_random().instantiate()
		drop_node.global_position = global_position
		Helper.get_enemy_spanwer().add_child(drop_node)

func _player_is_dead() -> void:
	player_alive = false

func _ended() -> void:
	die()

extends CharacterBody2D
class_name Player
# @onready var state_machine : StateMachine = $StateMachine

@export var move_speed : float = 200
@export var jump_force : float = 700
@export var gravity : float = 2000

@export var dash_force : float = 400

@export var acceleration : float = 1500
@export var friction : float = 1500

@export var wall_slide_g : float = 40

#can
var can_move : bool = true
var can_jump : bool = true

# jump
@export var jump_height : float = 400
@export var jump_time : float = 0.9
@export var fall_time : float = 1.0

var jump_velocity : float = (2 * jump_height) / jump_time * -1
var peak_velocity : float = (2 * jump_height) / (jump_time * jump_time)
var fall_velocity : float = (2 * jump_height) / (fall_time * fall_time)
var buffer_jump : float = 0.1
var has_buffer_jump : bool = false

# ground properties
@export var ground_acceleration : float = 1500
@export var ground_friction : float = 1500

# air properties
@export var air_acceleration : float = 1500
@export var air_friction : float = 1500

# walljump properties
@export var wj_acceleration : float = move_speed * 2
@export var wj_friction : float = move_speed / 10
@export var wj_time : float = 0.1
@export var wj_jump : float = 400
@export var wj_force : float = 300

#animation
@onready var animation_state : AnimatedSprite2D = $AnimatedSprite2D

#component
@onready var health_component : HealthComponent = $HealthComponent

#dash
var direction : Vector2 = Vector2.RIGHT
var can_dash = false
var dash_acceleration : float = 3000
var dash_friction : float = 3000
var has_acceleration = true
var has_friction = true

var is_affected_by_gravity : bool = true

# attack
var can_attack = true
var face_direction : Vector2 = Vector2.RIGHT
func _ready() -> void:
	add_group()
	wall_slide_g = fall_velocity / 8
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var input_dir = get_input_direction()

	if input_dir != Vector2.ZERO and can_move and has_acceleration:
		direction = input_dir if input_dir.x != 0 else direction
		accelerate(input_dir, delta)
	elif has_friction:
		deccelerate(delta)

	jump(delta)
	if is_affected_by_gravity:
		velocity.y += get_self_gravity() * delta
	move_and_slide()
	pass

func get_self_gravity():
	return peak_velocity if velocity.y < 0 else fall_velocity

func _process(delta: float) -> void:
	if get_input_direction().x < 0 and can_move:
		face_direction = Vector2.LEFT
		animation_state.flip_h = true
	elif get_input_direction().x > 0 and can_move:
		face_direction = Vector2.RIGHT
		animation_state.flip_h = false
	pass

func accelerate(direction, delta):
	velocity.x = velocity.move_toward(direction * move_speed, acceleration * delta).x

func deccelerate(delta):
	velocity.x = velocity.move_toward(Vector2.ZERO, friction * delta).x

func get_input_direction():
	var input_dir = Vector2.ZERO

	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	return input_dir

func jump(delta):
	# if Input.is_action_just_released("jump"):
	# 	velocity.y = max(velocity.y, velocity.y * 0.3)
	if not can_jump:
		return
	if has_buffer_jump:
		velocity.y = -jump_height
		has_buffer_jump = false

func add_jump_buffer():
	has_buffer_jump = true
	var timer = Timer.new()
	timer.set_wait_time(buffer_jump)
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func():
		has_buffer_jump = false
	)
	timer.start()


func add_group():
	add_to_group("entity")
	add_to_group("player")
	pass
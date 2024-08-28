extends Node
class_name PlayerMovementComponent

var can_move = true
var can_jump = false

@export var gravity = 500
@export var jump_force = 225
@export var max_move_speed = 100
@export var initial_move_speed = max_move_speed/4
@export var time_to_reach_max_speed = 0.10
@export var time_to_stop = 0.10

@export var time_to_walljump = 0.5
@export var wall_jump_component : WallJumpComponent = null

var can_reduce_jump = true
var move_speed = 0
var forced_direction = Vector2.ZERO

# GRAVITY
var velocity = Vector2.ZERO
var delta_velocity = Vector2.ZERO

func process(delta, on_floor: bool) -> Vector2:
	if on_floor:
		can_jump = true
		velocity.y = 0

	if wall_jump_component.can_wall_jump() and not on_floor:
		can_jump = true
	elif not on_floor:
		can_jump = false
	if Input.is_action_just_pressed("jump"):
		forced_direction = jump(on_floor)
	velocity = move(velocity, delta, forced_direction)
	velocity = apply_gravity(velocity, delta)
	return velocity

func get_direction_by_input(input_vector = Vector2.ZERO) -> Vector2:
	if input_vector == Vector2.ZERO or input_vector == null:
		input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return input_vector

func move(velocity, delta, forced_direction = Vector2.ZERO):
	if not can_move:
		return

	var direction = get_direction_by_input(forced_direction)
	var delta_velocity_sign = -1 if delta_velocity.x < 0 else 1 
	if direction.x != 0:
		if abs(delta_velocity.x) < max_move_speed or direction.x != delta_velocity_sign:
			delta_velocity.x += (max_move_speed / (time_to_reach_max_speed)) * delta * direction.x
			if abs(delta_velocity.x) > max_move_speed:
				delta_velocity.x = max_move_speed * delta_velocity_sign
	if direction.x == 0 and abs(delta_velocity.x) > 0:
		delta_velocity.x -= (max_move_speed / time_to_stop) * delta * delta_velocity_sign
		if abs(delta_velocity.x) <= initial_move_speed*time_to_stop:
			delta_velocity.x = 0
	velocity.x = delta_velocity.x
	#print(delta_velocity.x)
	return velocity

func _input(event):
	if event.is_action_released("jump") and can_reduce_jump:
		velocity.y *= 0.5
		can_reduce_jump = false

func jump(on_floor = false):
	if not can_jump:
		return Vector2.ZERO
	velocity.y = -jump_force
	can_jump = false
	can_reduce_jump = true
	if wall_jump_component.can_wall_jump() and not on_floor:
		print(wall_jump_component.get_wall_direction())
		forced_direction.x = wall_jump_component.get_wall_direction().x * -1
		var timer = Timer.new()
		add_child(timer)
		timer.set_wait_time(time_to_walljump)
		timer.one_shot = true
		timer.start()
		timer.timeout.connect(timer_walljump_timeout)
	else:
		forced_direction = Vector2.ZERO
	return forced_direction

func apply_gravity(velocity, delta):
	if delta == null:
		return
	velocity.y += gravity * delta
	return velocity

func timer_walljump_timeout():
	print("timer_walljump_timeout")
	forced_direction = Vector2.ZERO
	pass

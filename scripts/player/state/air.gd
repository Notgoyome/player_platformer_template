extends State

@export var player : Player = null

var once_fall = false
var once_jump = false

func enter():
	once_fall = false
	once_jump = false
	player.can_move = true
	player.can_jump = false
	player.acceleration = player.air_acceleration
	player.friction = player.air_friction

	pass

func process(delta: float) -> void:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max(player.velocity.y, player.velocity.y * 0.5)
	if Input.is_action_just_pressed("jump"):
		player.add_jump_buffer()
	if player.is_on_floor():
		emit_signal("state_finished", self, "Ground")
	if player.is_on_wall_only():
		emit_signal("state_finished", self, "Wall")
	if player.get_self_gravity() == player.fall_velocity and not once_fall:
		player.animation_state.speed_scale = 1/player.fall_time
		player.animation_state.play("fall")
		once_fall = true
	elif player.get_self_gravity() == player.peak_velocity and not once_jump:
		player.animation_state.speed_scale = 1/player.jump_time
		player.animation_state.play("jump")
		once_jump = true
extends State

@export var player : Player = null

var once_fall = false
var once_jump = false
var coyote_time = 0.1
var coyote_timer = Timer.new()

func _ready():
	create_coyote_timer()

func enter():
	once_fall = false
	player.can_move = true
	# player.can_jump = true
	player.acceleration = player.air_acceleration
	player.friction = player.air_friction
	coyote_timer.start()
	pass

func process(delta: float) -> void:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max(player.velocity.y, player.velocity.y * 0.5)
	if Input.is_action_just_pressed("jump"):
		player.add_jump_buffer()
	if player.is_on_floor():
		emit_signal("state_finished", self, "Ground")
		return
	if Input.is_action_just_pressed("attack") and player.can_attack:
		emit_signal("state_finished", self, "Attack")
		return
	if player.is_on_wall_only():
		emit_signal("state_finished", self, "Wall")
		return
	if player.get_self_gravity() == player.fall_velocity and not once_fall:
		player.animation_state.speed_scale = 1/player.fall_time
		player.animation_state.play("fall")
		once_fall = true
	if Input.is_action_just_pressed("dash"):
		emit_signal("state_finished", self, "Dash")
		return
	elif player.get_self_gravity() == player.peak_velocity and not once_jump:
		player.animation_state.speed_scale = 1/player.jump_time
		player.animation_state.play("jump")
		once_jump = true

func create_coyote_timer():
	coyote_timer.set_wait_time(coyote_time)
	coyote_timer.set_one_shot(true)
	coyote_timer.start()
	coyote_timer.timeout.connect(func():
		player.can_jump = false
	)
	add_child(coyote_timer)

func exit():
	coyote_timer.stop()
	player.animation_state.speed_scale = 1
	player.can_jump = false
extends State

@export var player : Player = null
var timer = null
var slide_animation_once = false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	player.can_move = false
	player.can_jump = false
	player.acceleration = player.air_acceleration
	player.friction = player.air_friction

	timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.set_one_shot(true)
	timer.timeout.connect(func():
		player.can_move = true
	)
	add_child(timer)
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	wall_slide(delta)
	if player.is_on_floor():
		emit_signal("state_finished", self, "Ground")
		return
	if not player.is_on_wall_only():
		emit_signal("state_finished", self, "Air")
		return
	if Input.is_action_just_pressed("jump") or player.has_buffer_jump:
		timer.stop()
		emit_signal("state_finished", self, "WallJump")
		player.has_buffer_jump = false
		return
	pass

func wall_slide(delta):
	if player.is_on_wall_only() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		if slide_animation_once == false:
			player.animation_state.play("wall_slide_right")
			slide_animation_once = true
		player.velocity.y -= (player.wall_slide_g * delta)
		player.velocity.y = min(player.velocity.y, player.wall_slide_g)
		# player.animation_state.stop()
	elif player.is_on_wall_only():
		slide_animation_once = false
	animate_wall()


func animate_wall():
	if player.get_wall_normal().x > 0:
		player.animation_state.play("wall_slide_right")
		#reerses the animation
		player.animation_state.flip_h = true
		player.animation_state.frame = 0
	else:
		player.animation_state.play("wall_slide_right")
		player.animation_state.frame = 0
		player.animation_state.flip_h = false
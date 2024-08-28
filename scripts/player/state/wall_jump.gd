extends State

@export var player : CharacterBody2D = null
var wj_jump_dir = 0
var can_dash = true
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	can_dash = true
	player.can_move = false
	player.can_jump = false
	player.acceleration = player.wj_acceleration
	player.friction = player.wj_friction

	var wall_normal = player.get_wall_normal()
	wj_jump_dir = 0
	if wall_normal.x > 0:
		wj_jump_dir = 1
	else:
		wj_jump_dir = -1
	if can_dash:
		player.velocity.y = -player.wj_jump
		player.velocity.x = wj_jump_dir * player.wj_force
		can_dash = false
	
	player.animation_state.speed_scale = 1/player.jump_time
	player.animation_state.play("jump")
	player.animation_state.flip_h = wj_jump_dir != 1

	var timer = Timer.new()
	timer.set_wait_time(player.wj_time)
	timer.set_one_shot(true)
	timer.timeout.connect(func():
		if player.is_on_wall_only():
			emit_signal("state_finished", self, "Wall")
		else:
			emit_signal("state_finished", self, "Air")
	)
	add_child(timer)
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	if Input.is_action_just_released("jump"):
		player.velocity.y = max(player.velocity.y, player.velocity.y * 0.8)
		player.velocity.x = player.velocity.move_toward(Vector2.ZERO, abs(player.velocity.x * 0.4)).x
	player.velocity.x = player.velocity.move_toward(Vector2.ZERO, player.friction * delta).x
	if player.is_on_floor():
		emit_signal("state_finished", self, "Ground")
		return
	if player.is_on_wall_only():
		print('wall')
		emit_signal("state_finished", self, "Wall")
		return
	if Input.is_action_just_pressed("jump"):
		print('buffer')
		player.add_jump_buffer()
		return
	pass

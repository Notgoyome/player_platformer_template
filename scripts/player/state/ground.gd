extends State

@export var player : CharacterBody2D = null

func enter():
	player.can_move = true
	player.can_jump = true
	player.acceleration = player.ground_acceleration
	player.friction = player.ground_friction
	pass

func process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		player.add_jump_buffer()
	if not player.is_on_floor():
		emit_signal("state_finished", self, "Air")
	if player.velocity == Vector2.ZERO:
		player.animation_state.play("idle")
	if player.get_input_direction().x < 0:
		player.animation_state.flip_h = true
		player.animation_state.play("run")
	elif player.get_input_direction().x > 0:
		player.animation_state.flip_h = false
		player.animation_state.play("run")
	pass
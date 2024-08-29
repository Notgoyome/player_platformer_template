extends State

@export var player : Player = null
@export var health_component : HealthComponent = null

var dash_length : float = 80.0
var dash_time : float = 0.25
var velocity_memory : Vector2 = Vector2.ZERO
var dash_velocity : Vector2 = Vector2.ZERO
var dash_timer : Timer = Timer.new()

var dash_cool_down : float = 1.5
var dash_cool_down_timer : Timer = Timer.new()

var can_dash = true
func enter():
	if not player.can_dash:
		return_signal()
		return
	player.is_affected_by_gravity = false
	player.can_move = false
	player.can_jump = false
	velocity_memory = player.velocity
	player.acceleration = player.dash_acceleration
	player.friction = player.dash_friction
	player.has_acceleration = false
	player.has_friction = false
	player.velocity = Vector2.ZERO
	player.velocity.x = dash_velocity.x * player.direction.x
	dash_timer.start()
	
	if health_component:
		health_component.invincible = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_velocity.x = dash_length / (dash_time)
	dash_timer.set_wait_time(dash_time)
	dash_timer.set_one_shot(true)
	add_child(dash_timer)
	
	dash_timer.timeout.connect(return_signal)
	player.can_dash = false
	pass # Replace with function body.


#s Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	if not player.can_dash:
		return_signal()
		return
	player.velocity.y = 0
	player.animation_state.speed_scale = 1/dash_time
	player.animation_state.play("dash")
	if player.is_on_wall_only():
		emit_signal("state_finished", self, "Wall")
	if Input.is_action_just_pressed("attack") and player.can_attack:
		emit_signal("state_finished", self, "Attack")
		return
	pass

func return_signal():
	if player.is_on_floor():
		print("Dash finished")
		emit_signal("state_finished", self, "Ground")
		return
	if player.is_on_wall_only():
		emit_signal("state_finished", self, "Wall")
		return
	if Input.is_action_just_pressed("attack") and player.can_attack:
		emit_signal("state_finished", self, "Attack")
		return
	if Input.is_action_just_pressed("jump"):
		player.add_jump_buffer()
	emit_signal("state_finished", self, "Air")
	pass

func exit():
	player.can_dash = false
	player.animation_state.speed_scale = 1
	player.has_acceleration = true
	player.has_friction = true
	player.is_affected_by_gravity = true
	player.animation_state.stop()
	dash_timer.stop()
	if health_component:
		health_component.invincible = false
	pass

func create_cd_timer():
	dash_cool_down_timer.set_wait_time(dash_cool_down)
	dash_cool_down_timer.set_one_shot(true)
	add_child(dash_cool_down_timer)
	dash_cool_down_timer.start()
	dash_cool_down_timer.timeout.connect(_on_dash_cool_down_timer_timeout)
	pass

func _on_dash_cool_down_timer_timeout():
	player.can_dash = true
	pass
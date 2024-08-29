extends State

@export var player : Player = null
var attack_speed : float = 2.0
var attack_number : int = 0
var attack_time : float = 0.3 / attack_speed#opti a opti
var attack_time2 : float = 0.8 / attack_speed
var attack_timer : Timer = Timer.new()
var reset_timer : Timer = Timer.new()
var attack_index : int = 0
var attack_index_max : int = 1
var ad_multiplier : float = 1.0
var ad_multiplier2 : float = 1.0
var ad_multiplier3 : float = 1.0

var reset_time : float = 1.0

var animation = {
	0 : "attack1",
	1 : "attack2",
}

@export var attack_scene : PackedScene = null
var attack_node : Node2D = null

func _ready():
	create_attack_timer()
	create_reset_timer()

# Called when the node enters the scene tree for the first time.
func enter():

	player.animation_state.speed_scale = attack_speed*0.5 / (attack_time)
	player.animation_state.play(animation[attack_index])
	attack_timer.start()
	player.can_attack = false
	player.can_move = false
	attack()
func process(delta: float) -> void:
	# player.velocity = Vector2.ZERO
	pass

func create_attack_timer():
	attack_timer.set_wait_time(attack_time)
	attack_timer.set_one_shot(true)
	add_child(attack_timer)
	attack_timer.timeout.connect(attack_timeout)

func create_reset_timer():
	reset_timer.set_wait_time(reset_time)
	reset_timer.set_one_shot(true)
	add_child(reset_timer)
	reset_timer.timeout.connect(reset_func)

func attack_timeout():
	attack_node.queue_free()
	reset_timer.stop()
	reset_timer.start()
	# attack_index = max(attack_index + 1, attack_index_max)
	attack_index = attack_index + 1
	if attack_index > attack_index_max:
		attack_index = 0
	player.can_attack = true
	emit_signal("state_finished", self, "Air")

func reset_func():
	attack_index = 0

func attack():
	attack_node = attack_scene.instantiate()
	attack_node.parent = player
	attack_node.damage = 10 # a
	if player.animation_state.flip_h:
		attack_node.position.x -= 19
	else:
		attack_node.position.x += 19
	player.add_child(attack_node)

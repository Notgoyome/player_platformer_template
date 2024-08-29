extends State

@export var ray_component: RayComponent
@export var bullet : PackedScene
var ray : RayCast2D = null
var ray_line : Line2D = null
var angle = 0
var player : Player = null
var vector_to_player = Vector2.ZERO
var attention_time = 1
var has_attention = false
var attention_timer : Timer = null
var old_vector_to_player = Vector2.ZERO
var shoot_rate = 0.5
var shoot_timer : Timer = null

var reaction_timer : Timer = null
var reaction_time = 0.2
var has_reaction = false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	create_attention_timer()
	create_shoot_timer()
	create_reaction_timer()
	pass # Replace with function body.

func enter() -> void:
	has_reaction = false
	reaction_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	process_ray()
	process_shot()
	pass

func process_shot():
	if player != null and has_attention and shoot_timer.is_stopped() and has_reaction:
		
		var direction = vector_to_player.normalized()
		shoot()
		shoot_timer.start()
	pass

func shoot():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = ray_component.global_position
	new_bullet.direction = vector_to_player.normalized()
	get_parent().add_child(new_bullet)
	
func process_ray():
	angle = ray_component.angle
	ray = ray_component.ray
	ray_line = ray_component.ray_line
	ray_component.angle = vector_to_player.angle()
	process_line()
	process_ray2D()
	if ray.is_colliding() and ray.get_collider().is_in_group("player"): #opti
		player = ray.get_collider()
		has_attention = true
		attention_timer.start()
	if player != null and has_attention:
		vector_to_player = player.global_position - ray_component.global_position

func process_line():
	ray_component.ray_line.clear_points()
	ray_component.ray_line.add_point(Vector2(0, 0))
	var point = ray.target_position
	if ray.is_colliding():
		point = ray.target_position
		var distance = ray_component.ray.global_position.distance_to(ray.get_collision_point())
		point = Vector2(cos(ray_component.angle), sin(ray_component.angle)) * distance
	ray_line.add_point(point)

func process_ray2D():
	ray_component.angle = vector_to_player.angle()
	ray_component.ray.target_position = vector_to_player
	if ray_component.ray.target_position.length() > ray_component.ray_range:
		ray_component.ray.target_position = ray_component.ray.target_position.normalized() * ray_component.ray_range
	pass

func exit():
	attention_timer.stop()
	shoot_timer.stop()
	has_reaction = false



## TIMER 

func create_attention_timer():
	attention_timer = Timer.new()
	add_child(attention_timer)
	attention_timer.timeout.connect(func():
		has_attention = false
		ray_component.angle = vector_to_player.angle()
		emit_signal("state_finished", self, "scan")
	)
	attention_timer.wait_time = attention_time
	attention_timer.one_shot = true
	pass # Replace with function 

func create_shoot_timer():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.timeout.connect(func():
		pass
	)
	shoot_timer.wait_time = shoot_rate
	shoot_timer.one_shot = true
	pass # Replace with function

func create_reaction_timer():
	reaction_timer = Timer.new()
	add_child(reaction_timer)
	reaction_timer.timeout.connect(func():
		has_reaction = true
		pass
	)
	reaction_timer.wait_time = reaction_time
	reaction_timer.one_shot = true
	pass # Replace with function

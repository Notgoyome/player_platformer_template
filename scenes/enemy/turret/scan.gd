extends State

@export var ray_component: RayComponent
@export var rotatable = false
@export var wave_scan = true
@export var starting_angle = 0
var wave_delta = 0
var ray : RayCast2D = null
var ray_line : Line2D = null
@export var angle : float = 180
var speed_rotation = 1
@onready var point_sprite : Sprite2D = $point
# Called when the node enters the scene tree for the first time.

func _ready():
	point_sprite.hide()
	var new_vector = point_sprite.global_position - ray_component.global_position
	var angle = new_vector.angle()
	# angle = point_sprite.global_position.angle_to(ray_component.global_position)
	ray_component.angle = angle
	starting_angle = angle
	pass # Replace with function body.

func enter():
	
	pass # Replace with function body.

func process(delta):

	if rotatable:
		ray_component.angle = (ray_component.angle + delta * speed_rotation)
	if wave_scan:
		wave_delta += delta * speed_rotation
		if wave_delta >= 2 * PI:
			wave_delta -= 2 * PI
		ray_component.angle = (ray_component.angle + cos(wave_delta) * ((angle / 180) * PI) / 100)
		ray_component.angle = clamp(ray_component.angle, starting_angle - angle, starting_angle + angle)
	ray = ray_component.ray
	ray_line = ray_component.ray_line

	#make it moves
	ray_component.ray.target_position = Vector2(cos(ray_component.angle), sin(ray_component.angle)) * ray_component.ray_range
	if ray.is_colliding() and ray.get_collider().is_in_group("player"):
		emit_signal("state_finished", self, "hunt")
	process_line()
	pass

func exit():
	pass

func process_line():
	ray_component.ray_line.clear_points()
	ray_component.ray_line.add_point(Vector2(0, 0))
	var point = ray.target_position
	if ray.is_colliding():
		point = ray.target_position
		var distance = ray_component.ray.global_position.distance_to(ray.get_collision_point())
		point = Vector2(cos(ray_component.angle), sin(ray_component.angle)) * distance
	ray_line.add_point(point)

extends Node2D
class_name RayComponent
var ray: RayCast2D = RayCast2D.new()
var ray_range: float = 1000
var angle = 0
var ray_line: Line2D = Line2D.new()

@onready var icon: Sprite2D = $Icon

func _ready():
    create_ray2D()
    create_ray_line()
    pass

func _process(delta: float) -> void:
    pass


func create_ray2D() -> void: #opti a opti
    ray = RayCast2D.new()
    add_child(ray)

    ray.enabled = true

    var ray_vector = Vector2(sin(angle), cos(angle))


    ray.target_position = ray_vector * ray_range


    ray.set_collision_mask_value(3, true)
    ray.set_collision_mask_value(0, false)
    ray.set_collision_mask_value(1, true)

    pass

func create_ray_line():
    ray_line = Line2D.new()
    ray_line.width = 1
    ray_line.default_color = Color(1, 0, 0)
    add_child(ray_line)

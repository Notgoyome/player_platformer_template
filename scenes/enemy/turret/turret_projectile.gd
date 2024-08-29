extends EnemyProjectile

class_name TurretProjectile

var direction = Vector2(0, 0)
var speed = 100
var damage = 1
var bullet_life = 5
var timer = Timer.new()
func _ready():
    timer.set_wait_time(bullet_life)
    timer.set_one_shot(true)
    var callback = func():
        queue_free()
    timer.timeout.connect(callback)
    add_child(timer)
    timer.start()
    pass # Replace with function body.

func _process(delta: float) -> void:
    position += direction * speed * delta
    pass # Replace with function body.

func _on_area_2d_body_entered(body:Node2D) -> void:
    if body.is_in_group("player"):
        body.health_component.damage(damage)
        queue_free()
    if body is TileMapLayer:
        queue_free()
    pass # Replace with function body.

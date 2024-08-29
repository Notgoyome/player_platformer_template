extends Spell

class_name Fireball

@export var speed = 400
@export var damage = 10
@export var time_duration = 0.05
@export var push_force = 300
@export var push_area : CollisionShape2D
@export var does_push = true
@export var collide = true
var entity_list = []

func _ready() -> void:
	var timer = Timer.new()
	timer.set_wait_time(time_duration)
	timer.set_one_shot(true)
	var callback = func():
		push_all()
		queue_free()
	timer.timeout.connect(callback)
	add_child(timer)
	timer.start()
	pass

func _process(delta: float) -> void:
	move_and_collide(direction * speed * delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	#check the layer
	if body is TileMapLayer and collide:
		push_all()
		queue_free()
	pass # Replace with function body.


func _on_push_area_body_entered(body: Node2D) -> void:
	if body is Player:
		entity_list.append(body)
	pass # Replace with function body.


func _on_push_area_body_exited(body: Node2D) -> void:
	if body is Player:
		entity_list.erase(body)
	pass # Replace with function body.

func push_all() -> void:
	if !does_push:
		return
	for entity in entity_list:
		push(entity)
	pass

func push(body: Node2D) -> void:
	if body is Player:
		var direction = body.global_position - global_position
		direction = direction.normalized()
		var dividor = abs(body.global_position - global_position) / push_area.shape.radius
		dividor.x = min(max(0.60, dividor.x), 4)
		dividor.y = min(max(0.60, dividor.y), 4)
		body.velocity += (direction * push_force) / (dividor)
		print("pushed")
	pass

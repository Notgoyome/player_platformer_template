extends CharacterBody2D

@export var movement_component : PlayerMovementComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#check if player is stickinkg the wall
	if movement_component:
		velocity = movement_component.process(delta, is_on_floor())
	move_and_slide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

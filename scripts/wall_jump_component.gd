extends Node2D
class_name WallJumpComponent
var wallDirection = Vector2.ZERO
var can_walljump_left = false
var can_walljump_right = false
var can_walljump = false
var wall_jump_initial_force = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_left_body_entered(body:Node2D) -> void:
	#check if the body is the player
	if body.name == "Player":
		return
	wallDirection = Vector2.LEFT
	can_walljump_left = true
	pass # Replace with function body.

func _on_right_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		return
	wallDirection = Vector2.RIGHT
	can_walljump_right = true
	pass # Replace with function body.



func _on_left_body_exited(body:Node2D) -> void:
	can_walljump_left = false
	pass # Replace with function body.

func _on_right_body_exited(body:Node2D) -> void:
	can_walljump_right = false
	pass # Replace with function body.

func can_wall_jump() -> bool:
	return can_walljump_left or can_walljump_right

func get_wall_direction() -> Vector2:
	return wallDirection
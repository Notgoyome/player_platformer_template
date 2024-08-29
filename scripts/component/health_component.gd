extends Node2D

class_name HealthComponent

@export var target_kill : Node2D = null
@export var max_health : int = 1

var health : int = 0
@export var invincible : bool = false
func _ready() -> void:
    health = max_health
    pass

func damage(damage : int) -> void:
    if invincible:
        return
    health -= damage
    if health <= 0:
        if target_kill:
            target_kill.queue_free()
    pass
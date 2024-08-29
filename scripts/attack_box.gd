extends Node2D

class_name attack

var damage : int = 1
var parent : Node2D = null

var list_body : Array = []

func _on_area_2d_body_entered(body:Node2D) -> void:
    #if body has healthcomponent in child
    print("body entered", body.name)
    if body == parent:
        return
    print(body.has_node("HealthComponent"))
    if body.has_node("HealthComponent") and not list_body.has(body):
        var health : HealthComponent = body.get_node("HealthComponent")
        health.damage(damage)
        list_body.append(body)
    
    pass # Replace with function body.

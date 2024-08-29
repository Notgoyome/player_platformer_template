extends Node2D

class_name SpellComponent

@export var fireball : PackedScene

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    # if Input.is_action_just_pressed("dash"):
    #     cast()
    pass

func cast() -> void:
    var spell = fireball.instantiate()

    var root = get_tree().get_root()
    root.add_child(spell)

    spell.position = global_position

    var mouse_pos = get_global_mouse_position()
    var direction = (mouse_pos - global_position).normalized()
    spell.direction = direction
    pass

func _input(event: InputEvent) -> void:
    pass
    # if event is InputEventMouseButton:
    #     if event.is_pressed():
    #         cast()
    #     pass
    # pass
    # if event is InputEventKey:
    #     if event.is_pressed() and event.
    #         cast()
    #     pass
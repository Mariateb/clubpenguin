extends Node2D

@export var distance: float
@export var base_position: Vector2

func _init() -> void:
	base_position.x = 420
	base_position.y = 360

func _physics_process(_delta: float):
	position = base_position + get_global_mouse_position() / distance

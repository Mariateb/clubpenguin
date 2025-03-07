extends Sprite2D

var base_position: Vector2

func _init() -> void:
	base_position = position

func _process(_delta: float):
	position.x = (base_position + (get_global_mouse_position() - base_position) * 10 / max(get_global_mouse_position().distance_to(base_position), 1) + get_global_mouse_position() / 10.0).x
	position.y = (base_position + (get_global_mouse_position() - base_position) * 3 / max(get_global_mouse_position().distance_to(base_position), 1) + get_global_mouse_position() / 10.0).y

class_name Living

extends Node2D

signal over_healed(ammount: float)
signal dies

@export var max_health_points: float
@export var move_speed: float
@export var looking_direction: Vector2 = Vector2.RIGHT

@export var health_points: float:
	get:
		return health_points
	set(value):
		health_points = max(health_points + value, max_health_points)
		if health_points < 0.0:
			health_points = 0.0
			dies.emit()

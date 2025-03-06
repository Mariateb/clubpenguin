class_name Living

extends Node2D

signal over_healed(ammount: float)
signal dies

@export var max_health_points: float
@export var move_speed: float
@export var looking_direction: float

@export var health_points: float:
	get:
		return health_points
	set(value):
		health_points += value
		if health_points < 0.0:
			health_points = 0.0
			dies.emit()
		elif health_points > max_health_points:
			var over_health = max_health_points - health_points
			health_points = max_health_points
			over_healed.emit(over_health)

extends Node2D

class_name Monster

@export var speedMove : int = 300

@onready var target: Node2D = $"../Player"


func _process(delta):
	var pos = position - target.position
	
	if pos.x < 0:
		position.x += 1
	else:
		position.x -= 1
	
	if pos.y < 0:
		position.y += 1
	else:
		position.y -= 1
	
	if position.length() < 0:
		return
	
	pass

class_name Generator

extends Node2D

const maxBoidsAlive: int = 140

func _ready():
	var boids = Boids.new($"../Player", maxBoidsAlive)
	add_child(boids)
	pass

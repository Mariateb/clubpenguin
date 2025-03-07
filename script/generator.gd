class_name Generator

extends Node2D

const maxBoidsAlive: int = 25

func _ready():
	for i in range(maxBoidsAlive):
		var boids = Boids.new($"../Player")
		
		boids.name = "__boids" + str(i)
		boids.position.x += randi() % 1000
		boids.position.y += randi() % 1000
		
		add_child(boids)
	pass

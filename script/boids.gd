extends Node2D

class_name Boids

var capacityGroup: int;
var target: Player
var old_pos: Vector2 = Vector2.ZERO
const radius = 128*3

func _init(target: Player, capacity: int):
	self.target = target
	self.capacityGroup = (randi() % capacity - 10) + 10
	for i in range(capacityGroup):
		var monster = Monster.new(target)
		monster.position.x = randi() % 1000
		monster.position.y = randi() % 1000
		monster.set_target(target)
		monster.name = "__monster" + str(i)
		add_child(monster)
	pass

#func _ready() -> void:

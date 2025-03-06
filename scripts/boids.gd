extends Node2D

class_name Boids

var capacityGroup: int = randi() % 4;
var target: Player
const radius = 128*3


func _init(target: Player):
	self.target = target
	pass

func _ready() -> void:
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	collision.shape = shape
	
	collision.name = "__boidCollision"
	
	add_child(collision)

	for i in range(capacityGroup):
		var monster = Monster.new()
		monster.name = "__monster" + str(i)
		add_child(monster)

func _process(delta):
	var pos = position - target.position
	
	if pos.x < 0:
		position += Vector2.RIGHT
	else:
		position += Vector2.LEFT

	if pos.y < 0:
		position += Vector2.DOWN
	else:
		position += Vector2.UP
	
	print(pos)

	pass

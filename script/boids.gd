extends Node2D

class_name Boids

var capacityGroup: int = randi() % 10;
var target: Player
var old_pos: Vector2 = Vector2.ZERO
const radius = 128*3

func _init(target: Player):
	self.target = target
	pass

func _ready() -> void:
	for i in range(capacityGroup):
		var monster = Monster.new(target)
		monster.set_target(target)
		monster.name = "__monster" + str(i)
		add_child(monster)

# Bois will always go to attack the target.
func _process(delta):
	
	if target.position == old_pos:
		return
	
	for boid in get_children():
		boid._process(delta)
	
	old_pos = target.position

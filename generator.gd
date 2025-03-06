extends Node2D

@onready var platform: Node2D = $"../Node2D"
@export var MobComponent: Node2D

var monsterAlive = 0

func _process(delta):
	var monsterAlive = platform.find_children("__monster") 
	while len(monsterAlive) < 10:
		var test = Node2D.new()
		test.name = "__monsrer"
		
		platform.add_child(test)
	
func handleSpawner():
	pass

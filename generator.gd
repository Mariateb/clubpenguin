extends Node2D

@onready var platform: Node2D = $"../Node2D"
@export var MobComponent: Node2D

var monsterAlive = 0

func _ready():
	var monsterAlive = len(platform.find_children("__monster"))
	var test = Node2D.new()
	test.name = "__monster" + str(monsterAlive)
	platform.add_child(test)
	monsterAlive+=1
	
func handleSpawner():
	pass

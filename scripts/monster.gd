class_name Monster

extends Living

enum AttackState{
	LINEAR,
	BOIDS,
}

enum MonsterState{
	REUNITE,
	DIVIDE,
	ATTACK,
}

@export var attack: AttackState = AttackState.BOIDS
@export var speedMove : int = 300
@onready var texture = load("res://sprites/poignant.png")
@onready var state: MonsterState = MonsterState.ATTACK

func _ready() -> void:
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 128
	collision.shape = shape
	collision.name = "__Collision"
	add_child(collision)
	
	self.z_index = 1
	var sprit2D = Sprite2D.new()
	sprit2D.texture = texture
	add_child(sprit2D)

var angle = 0
var speed = 2

func _process(delta):
	
	pass

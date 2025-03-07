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
var rigidbody = RigidBody2D.new()


func _ready() -> void:
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 128
	collision.shape = shape
	collision.name = "__Collision"
	rigidbody.add_child(collision)
	add_child(rigidbody)
	
	self.z_index = 1
	var sprit2D = Sprite2D.new()
	sprit2D.texture = texture
	add_child(sprit2D)

var angle = 0
var speed = 2

func _physics_process(delta: float) -> void:
	pass

"""
 Instead to only be 
"""
func _process(delta) -> void:
	
	
	pass

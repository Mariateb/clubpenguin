class_name Player

extends Living
@export var move_speed: float = 200.0
@onready var camera = $Camera2D

func _ready():
	camera.position = position

signal show_level_up()

@export var required_experience_until_next_level: float = 25.0
@export var experience_gain: float = 0.5
@export var experience_points: float = 0:
	get:
		return experience_points
	set(value):
		experience_points += value * experience_gain
		if experience_points >= required_experience_until_next_level:
			show_level_up.emit()

func _init() -> void:
	max_health_points = 100.0
	health_points = 100.0
	move_speed = 200.0
	
	self.over_healed.connect(over_healed_callback)

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if direction.length() > 0:
		direction = direction.normalized()
	
	# looking_direction is the angle to the mouse
	self.looking_direction = get_global_mouse_position().angle()
	
	self.global_position += direction * move_speed * delta

func over_healed_callback(amount: float):
	self.experience_gain += amount * 0.1

func level_up():
	max_health_points *= 1.05
	health_points = max_health_points
	experience_points = 0
	required_experience_until_next_level *= 1.5

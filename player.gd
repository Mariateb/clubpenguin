class_name Player

extends Living

signal show_level_up()
@export var direction = Vector2.LEFT

var weapons: Array = []


@export var level: int = 1
@export var required_experience_until_next_level: float = 25.0
@export var experience_gain: float = 0.5
@export var experience_points: float = 0:
	get:
		return experience_points
	set(value):
		experience_points = value
		if experience_points >= required_experience_until_next_level:
			show_level_up.emit()
			level_up()

func _ready() -> void:
	max_health_points = 100.0
	health_points = 100.0
	move_speed = 200.0
	equip_weapon(Slash.new(self))


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		position = position + (Vector2.LEFT * move_speed * delta)
		looking_direction = Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		position = position + (Vector2.RIGHT * move_speed * delta)
		looking_direction = Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		position = position + (Vector2.UP * move_speed * delta)
		looking_direction = Vector2.UP
		experience_points += 1
	if Input.is_action_pressed("move_down"):
		position = position + (Vector2.DOWN * move_speed * delta)
		looking_direction = Vector2.DOWN

func level_up():
	max_health_points *= 1.05
	health_points = max_health_points
	experience_points = 0
	level += 1
	required_experience_until_next_level *= 1.5

func equip_weapon(weapon: Weapon):
	weapons.push_back(weapon)
	add_child(weapon)

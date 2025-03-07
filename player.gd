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

var area = Area2D.new()

func _ready() -> void:
	var collision = CollisionShape2D.new()
	var rect = RectangleShape2D.new()

	rect.size = Vector2(18, 18)
	collision.shape = rect
	area.collision_layer = 1 << 3
	area.collision_mask = 1 << 2
	area.z_index=1
	
	area.add_child(collision)
	add_child(area)
	
	max_health_points = 100.0
	health_points = 100.0
	move_speed = 200.0
	equip_weapon(Slash.new(self))
	$Sprite2D.play("idle")

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("move_up"):
		position = position + (Vector2.UP * move_speed * delta)
		looking_direction = Vector2.UP
		scale.x = -1
		$Sprite2D.play("walk")
	if Input.is_action_pressed("move_down"):
		position = position + (Vector2.DOWN * move_speed * delta)
		looking_direction = Vector2.DOWN
		scale.x = 1
		$Sprite2D.play("walk")
	if Input.is_action_pressed("move_left"):
		position = position + (Vector2.LEFT * move_speed * delta)
		looking_direction = Vector2.LEFT
		scale.x = -1
		$Sprite2D.play("walk")
	if Input.is_action_pressed("move_right"):
		position = position + (Vector2.RIGHT * move_speed * delta)
		looking_direction = Vector2.RIGHT
		scale.x = 1
		$Sprite2D.play("walk")
	if(Input.is_anything_pressed()==false):
		$Sprite2D.play("idle")

func level_up():
	max_health_points *= 1.05
	health_points = max_health_points
	experience_points = 0
	level += 1
	required_experience_until_next_level *= 1.5
	for weapon in weapons:
		weapon.level_up()

func equip_weapon(weapon: Weapon):
	weapons.push_back(weapon)
	add_child(weapon)

func take_damage(damage):
	health_points = health_points - damage

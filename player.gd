extends Node2D

@export var max_health_points: float = 100.0
@export var required_experience_until_next_level: float = 25.0
@export var experience_gain: float = 0.5

@export var move_speed: float = 200.0
@export var experience_points: float = 0.0
@export var health_points: float = 100.0
@export var force: float = 0.5

func _process(delta):
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
	
	position += direction * move_speed * delta

func level_up():
	max_health_points *= 1.05
	health_points = max_health_points
	force += 0.5
	experience_points = 0
	required_experience_until_next_level *= 1.5

func die():
	return

func obtain_experience_points(experience: float):
	experience_points += experience * experience_gain
	if experience_points >= required_experience_until_next_level:
		level_up()
		#TODO: afficher level up


func receive_damage(damage: float):
	health_points -= damage
	if health_points < 0.0:
		health_points = 0.0
		die()

# si on se soigne plus que nécessaire, on gagne de l'expérience
func receive_healing(heal: float):
	health_points += heal
	if health_points > max_health_points:
		var over_health = max_health_points - health_points
		health_points = max_health_points
		obtain_experience_points(over_health * 0.1)

func deal_damage():
	return force

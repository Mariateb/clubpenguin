extends AnimatedSprite2D

class_name Weapon

const ANIMATION = 'attack'

var player: Node2D
var hitbox: Area2D

var level: int = 0
var base_damage: Array = [10, 20, 30]
var speed: Array = [3, 3, 2]

func _init(p) -> void:
	player = p

func _ready() -> void:
	loop()

func level_up() -> void:
	if base_damage.size() < level + 1:
		level += 1

func loop() -> void:
	while true:
		set_direction()
		play(ANIMATION)
		attack()
		await animation_finished
		await get_tree().create_timer(1000 * speed[level])

func set_direction() -> void:
	var direction = player.get_direction()
	match direction:
		Vector2.UP:
			position = player.position + Vector2(0, -10)
			rotation_degrees = -90

		Vector2.DOWN:
			position = player.position + Vector2(0, 10)
			rotation_degrees = 90

		Vector2.LEFT:
			position = player.position + Vector2(-10, 0)
			rotation_degrees = 180
			scale.x = -1

		Vector2.RIGHT:
			position = player.position + Vector2(10, 0)
			rotation_degrees = 0
			scale.x = 1

func attack() -> void:
	# todo: check collisions
	pass
	#var collisions = hitbox.get_overlapping_bodies()  
	#for body in collisions:
		#if body is Monster:
			#body.take_damage(base_damage[level])

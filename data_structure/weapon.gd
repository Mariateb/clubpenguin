extends AnimatedSprite2D

class_name Weapon
const ANIMATION = 'attack'

var player: Player
var hitbox: Area2D

var weapon_name: String

var level: int = 0
var base_damage: Array = [10, 20, 30]
var cooldown: Array = [1.0, 1.0, 1.0]

func _init(p, wn) -> void:
	self.player = p
	self.weapon_name = wn
	z_index = 10
	init_animation()

func init_animation() -> void:
	var dir_path = "res://sprites/weapons/" + weapon_name + "/"
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var images = []
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with('.png'):
				images.push_back(filename)
			filename = dir.get_next()
		dir.list_dir_end()
		images.sort()
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_animation(ANIMATION)
		sprite_frames.set_animation_loop(ANIMATION, false)
		for image in images:
			sprite_frames.add_frame(ANIMATION, load(dir_path + image))

func _ready() -> void:
	loop()

func level_up() -> void:
	if base_damage.size() < level + 1:
		level += 1

func loop() -> void:
	while true:
		show()
		update_position()
		play(ANIMATION)
		#attack()
		await animation_finished
		hide()
		await get_tree().create_timer(cooldown[level]).timeout

func update_position() -> void:
	var x = 80
	match player.looking_direction:
		Vector2.UP:
			self.global_position = player.global_position + Vector2(0, -x)
			self.global_rotation_degrees = -90

		Vector2.DOWN:
			self.global_position = player.global_position + Vector2(0, x)
			self.global_rotation_degrees = 90

		Vector2.LEFT:
			self.global_position = player.global_position + Vector2(-x, 0)
			self.global_rotation_degrees = 180
			self.global_scale.x = -1

		Vector2.RIGHT:
			self.global_position = player.global_position + Vector2(x, 0)
			self.global_rotation_degrees = 0
			self.global_scale.x = 1

func attack() -> void:
	# todo: check collisions
	pass
	#var collisions = hitbox.get_overlapping_bodies()  
	#for body in collisions:
		#if body is Monster:
			#body.take_damage(base_damage[level])

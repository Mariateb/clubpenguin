extends Living

class_name Monster

# Paramètres des boids
var velocity = Vector2()
var acceleration = Vector2()
var max_speed = 150.0
var max_force = 5.0
var inner_radius = 30.0
var radius = 50.0  # Rayon d'influence pour les comportements de flocking

var player: Player

# Poids pour l'alignement, la cohésion, la séparation et le suivi de la cible
var alignment_weight = 0.3
var cohesion_weight = 10
var separation_weight = 100
var follow_weight = 2  # Poids pour le suivi d'une cible (si applicable)


var speed = 100.0
var target : Node2D  # Cible à suivre (si défini)

var boid_group : Array = []  # Groupe des boids voisins à traiter
var sprite : Sprite2D

var area = Area2D.new()

var damage = 12
var is_colliding = false
var damage_cooldown = 0
var damage_interval = 1.5

# Initialisation avec une cible
func _init(target_pos: Node2D):
	var collision = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(18, 18)
	collision.shape = rect
	area.collision_layer = 1 << 2
	area.collision_mask = 1 << 3

	area.z_index=1;
	area.add_child(collision)
	add_child(area)
	
	self.target = target_pos

# Initialisation du boid dans le jeu
func _ready():
	self.z_index = 1
	sprite = Sprite2D.new()
	sprite.texture = load("res://penguinsprites/enemies/crab/crab2.png")
	add_child(sprite)

	velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed
	max_health_points = 30.0
	health_points = 30.0
	dies.connect(_die)

	player = get_tree().get_root().get_node("Node2D/Jeu/Player")

func _process(delta):
	if Global.paused == false:
		# Récupérer les voisins proches (pour éviter les boids trop loin)
		get_nearby_boids()

		# Appliquer les comportements
		var alignment = align()
		var cohesion = cohere()
		var separation = separate()
		var follow_target = follow()  # Attirer vers la cible

		# Appliquer les forces calculées
		acceleration = cohesion * cohesion_weight + follow_target * follow_weight + separation * separation_weight

		# Mettre à jour la vélocité et la limiter à la vitesse maximale
		var vel = lerp((velocity + acceleration), velocity.normalized() * alignment, alignment_weight) 
		velocity = vel.normalized() * min(vel.length(), max_speed)

		# Déplacer le boid
		global_position += velocity * delta

		# Appliquer une rotation fluide vers la direction du mouvement
		if velocity.length() > 0:
			rotation = lerp_angle(rotation, velocity.angle(), 0.1)

	for body in area.get_overlapping_areas():
		if body.get_parent() is Player:
			damage_cooldown -= delta
			if damage_cooldown <= 0:
				damage_cooldown = damage_interval
				player.take_damage(damage)

# Séparation : éviter la proximité des autres boids
func separate() -> Vector2:
	var nearest = global_position
	var first = true
	for boid in get_parent().get_children():
		var distance = global_position.distance_to(boid.global_position)
		if boid != self and (distance < global_position.distance_to(nearest) or first ) and distance < inner_radius:
			nearest = boid.global_position
			first = false
	
	return (global_position - nearest).normalized()

# Alignement : direction vers les autres boids proches
func align() -> float:
	var steer = velocity
	var count = 0

	for boid in boid_group:
		steer += (boid as Monster).velocity
		count += 1

	if count > 0:
		steer /= count

	return steer.length()

# Cohésion : se diriger vers la position moyenne des autres boids
func cohere() -> Vector2:
	var steer = Vector2()
	var count = 0

	for boid in boid_group:
		steer += (boid as Monster).velocity.normalized()
		count += 1

	if count > 0:
		steer /= count

	return steer

# Suivi de la cible : se diriger vers un point spécifique
func follow() -> Vector2:
	var target_direction = target.global_position - global_position

	target_direction = target_direction.normalized() * max_speed
	var steer_towards_target = target_direction - velocity
	if steer_towards_target.length() > max_force:
		steer_towards_target = steer_towards_target.normalized() * max_force

	return steer_towards_target

# Récupérer les boids voisins dans un rayon donné
func get_nearby_boids():
	boid_group.clear()
	for boid in get_parent().get_children():
		if boid is Monster and boid != self:
			if global_position.distance_to(boid.global_position) < radius:
				boid_group.append(boid)

# Ajouter une cible dynamique (par exemple, un joueur ou un objectif)
func set_target(new_target: Node2D):
	target = new_target

func take_damage(damage):
	health_points -= damage

func _die():
	print('Monster dies')
	queue_free()
	if player is Player:
		Global.kill_count += 1
		player.experience_points += player.experience_gain

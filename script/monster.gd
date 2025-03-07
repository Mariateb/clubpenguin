extends Living

class_name Monster

# Paramètres des boids
var velocity = Vector2()
var acceleration = Vector2()
var max_speed = 150.0
var max_force = 25
var radius = 100.0  # Rayon d'influence pour les comportements de flocking

# Poids pour l'alignement, la cohésion, la séparation et le suivi de la cible
var alignment_weight = 1
var cohesion_weight = 2
var separation_weight = 10.5
var follow_weight = 1 #Poids pour le suivi d'une cible (si applicable)

var speed = 100.0
var target : Node2D  # Cible à suivre (si défini)

var boid_group : Array = []  # Groupe des boids voisins à traiter
var sprite : Sprite2D

# Initialisation avec une cible
func _init(target_pos: Node2D):
	var area =Area2D.new()
	var collision = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(18, 18)
	collision.shape = rect
	area.collision_layer = 1 <<3

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

func _die():
	print('Monster dies')
	Global.kill_count += 1
	queue_free()

func _process(delta):
	
	# Récupérer les voisins proches (pour éviter les boids trop loin)
	get_nearby_boids()

	# Appliquer les comportements
	var alignment = align()
	var cohesion = cohere()
	var separation = separate()
	var follow_target = follow()  # Attirer vers la cible

	# Appliquer les forces calculées
	acceleration = alignment * alignment_weight + cohesion * cohesion_weight + separation * separation_weight + follow_target * follow_weight

	# Mettre à jour la vélocité et la limiter à la vitesse maximale
	velocity += acceleration
	velocity = velocity.normalized() * min(velocity.length(), max_speed)

	# Déplacer le boid
	position += velocity * delta

	# Appliquer une rotation fluide vers la direction du mouvement
	if velocity.length() > 0:
		rotation = lerp_angle(rotation, velocity.angle(), 0.1)

# Séparation : éviter la proximité des autres boids
func separate() -> Vector2:
	var steer = Vector2()
	var count = 0

	for boid in boid_group:
		if boid != self:
			var diff = position - boid.position
			steer += diff.normalized() / position.distance_to(boid.position)  # Force inversement proportionnelle à la distance
			count += 1

	if count > 0:
		steer /= count

	if steer.length() > 0:
		steer = steer.normalized() * max_speed - velocity
		if steer.length() > max_force:
			steer = steer.normalized() * max_force

	return steer

# Alignement : direction vers les autres boids proches
func align() -> Vector2:
	var steer = Vector2()
	var count = 0

	for boid in boid_group:
		if boid != self:
			steer += boid.velocity
			count += 1

	if count > 0:
		steer /= count
		steer = steer.normalized() * max_speed
		steer -= velocity
		if steer.length() > max_force:
			steer = steer.normalized() * max_force

	return steer

# Cohésion : se diriger vers la position moyenne des autres boids
func cohere() -> Vector2:
	var steer = Vector2()
	var count = 0

	for boid in boid_group:
		if boid != self:
			steer += boid.position
			count += 1

	if count > 0:
		steer /= count
		steer -= position
		steer = steer.normalized() * max_speed
		steer -= velocity
		if steer.length() > max_force:
			steer = steer.normalized() * max_force

	return steer

# Suivi de la cible : se diriger vers un point spécifique
func follow() -> Vector2:
	var pos = target.position - Vector2(randi_range(0, 500), randi_range(0, 500))
	
	var target_direction = pos - position
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
			if position.distance_to(boid.position) < radius:
				boid_group.append(boid)

# Ajouter une cible dynamique (par exemple, un joueur ou un objectif)
func set_target(new_target: Node2D):
	target = new_target

func take_damage(damage):
	health_points -= damage

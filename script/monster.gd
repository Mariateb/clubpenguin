extends Node2D

class_name Monster

# Boid parameters
var velocity = Vector2()
var acceleration = Vector2()
var max_speed = 100
var max_force = 10.0
var radius = 300  # The radius within which the boid will check other boids

# Other parameters
var alignment_weight = 1.0
var cohesion_weight = 3.0
var separation_weight = 10.5
var follow_weight = 1.0  # Poids de l'attraction vers la cible

var speed = 100.0  # Speed of the boid
var target : Node2D  # L'objectif à suivre, un Node2D pour avoir un point dans l'espace
var old_pos: Vector2 = Vector2.ZERO

func _init(target: Node2D):
	self.target = target

# Called when the node enters the scene tree for the first time.
func _ready():
	self.z_index = 1
	var sprite2d = Sprite2D.new()
	sprite2d.texture = load("res://sprites/poignant.png")
	add_child(sprite2d)
	
	# Set the initial velocity to a random direction
	velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target.position == old_pos:
		return
	
	# Apply the flocking behaviors
	var alignment = align()
	var cohesion = cohere()
	var separation = separate()
	var follow_target = follow()  # Ajout de la force qui attire vers la cible

	# Accumulate the forces
	acceleration = alignment * alignment_weight + cohesion * cohesion_weight + separation * separation_weight + follow_target * follow_weight

	# Update velocity with the applied forces
	velocity += acceleration

	# Clamp velocity to the maximum speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# Apply the velocity to move the boid
	position += velocity * delta

	# Reset acceleration for the next frame
	acceleration = Vector2()

	# Smooth rotation towards velocity direction
	if velocity.length() > 0:
		rotation = lerp_angle(rotation, velocity.angle(), 0.1)

# Separation: Avoid crowding nearby boids
func separate():
	var steer = Vector2()
	var count = 0

	# Look for nearby boids within the radius
	for boid in get_parent().get_children():
		if boid != self and position.distance_to(boid.position) < radius:
			var diff = position - boid.position
			steer += diff.normalized() / position.distance_to(boid.position)  # Inversely proportional to distance
			count += 1

	if count > 0:
		steer /= count

	if steer.length() > 0:
		steer = steer.normalized() * max_speed - velocity
		if steer.length() > max_force:
			steer = steer.normalized() * max_force

	return steer

# Alignment: Steer towards the average heading of nearby boids
func align():
	var steer = Vector2()
	var count = 0

	# Look for nearby boids within the radius
	for boid in get_parent().get_children():
		if boid != self and position.distance_to(boid.position) < radius:
			steer += boid.velocity
			count += 1

	if count > 0:
		steer /= count
		steer = steer.normalized() * max_speed
		steer -= velocity
		if steer.length() > max_force:
			steer = steer.normalized() * max_force

	return steer

# Cohesion: Steer towards the average position of nearby boids
func cohere():
	var steer = Vector2()
	var count = 0

	# Look for nearby boids within the radius
	for boid in get_parent().get_children():
		if boid != self and position.distance_to(boid.position) < radius:
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

# Follow the target: Calculate the force towards the target (optional)
func follow() -> Vector2:
	# If there is no target, return an empty force
	if target == null:
		return Vector2()

	# Direction towards the target
	var target_direction = target.position - position
	target_direction = target_direction.normalized() * max_speed
	
	# Force to steer the boid towards the target
	var steer_towards_target = target_direction - velocity
	if steer_towards_target.length() > max_force:
		steer_towards_target = steer_towards_target.normalized() * max_force

	return steer_towards_target

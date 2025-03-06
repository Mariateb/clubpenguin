extends TextureProgressBar

@export var player: Player
	
func _process(delay):
	max_value = player.max_health_points
	value = player.health_points

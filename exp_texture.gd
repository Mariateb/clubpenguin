extends TextureProgressBar

@export var player: Player
	
func _process(delay):
	max_value = player.required_experience_until_next_level
	value = player.experience_points

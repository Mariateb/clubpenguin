extends Label

@export var player: Player

func _process(delta):
	text = str(int(player.health_points)) + " / " + str(int(player.max_health_points))

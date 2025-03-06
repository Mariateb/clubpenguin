extends Camera2D

var character_sprite = get_parent()

func _ready():
	position = character_sprite.position
	

extends Weapon

class_name Slash

func _init(p: Player) -> void:
	super(p, 'slash')

func _ready():
	super._ready()

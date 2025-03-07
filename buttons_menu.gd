extends VBoxContainer

func _ready() -> void:
	$Button_jouer.connect("pressed", jouer_pressed)
	$Button_quitter.connect("pressed", quitter_pressed)

func jouer_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")

func quitter_pressed():
	get_tree().quit()

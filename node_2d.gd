extends Node2D

func _ready() -> void:
	$Panel.visible = false
	$Panel/VBoxContainer/Button.connect("pressed", button_reprendre)
	$Panel/VBoxContainer/Button2.connect("pressed", button_quitter)

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		$Panel.visible = !$Panel.visible

func button_reprendre():
	$Panel.visible = false

func button_quitter():
	get_tree().change_scene_to_file("res://menu.tscn")
	

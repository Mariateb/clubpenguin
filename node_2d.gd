extends Node2D

func _ready() -> void:
	$CanvasLayer/Panel.visible = false
	$CanvasLayer/Panel/VBoxContainer/Button.connect("pressed", button_reprendre)
	$CanvasLayer/Panel/VBoxContainer/Button2.connect("pressed", button_quitter)

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		$CanvasLayer/Panel.visible = !$CanvasLayer/Panel.visible

func button_reprendre():
	$CanvasLayer/Panel.visible = false

func button_quitter():
	get_tree().change_scene_to_file("res://menu.tscn")
	

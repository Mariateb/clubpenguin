extends Node2D

func _ready() -> void:
	$CanvasLayer/Pause_panel.visible = false
	$CanvasLayer/Pause_panel/VBoxContainer/Button.connect("pressed", button_reprendre)
	$CanvasLayer/Pause_panel/VBoxContainer/Button2.connect("pressed", button_quitter)
	$CanvasLayer/Death_panel.visible = false
	$CanvasLayer/Death_panel/VBoxContainer/VBoxContainer/Button.connect("pressed", button_redemarer)
	$CanvasLayer/Death_panel/VBoxContainer/VBoxContainer/Button2.connect("pressed", button_quitter)
	$Jeu/Player.dies.connect(ouvre_mort)

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		$CanvasLayer/Pause_panel.visible = !$CanvasLayer/Pause_panel.visible
		Global.paused = $CanvasLayer/Pause_panel.visible or $CanvasLayer/Death_panel.visible
	if Input.is_action_just_pressed("ui_end"):
		Global.paused = true
		ouvre_mort()

func ouvre_mort():
	$CanvasLayer/Death_panel/VBoxContainer/HBoxContainer/VBoxContainer/Label.text = "Score : " + str($CanvasLayer/HUD/TimerLabel.elapsed_time)
	$CanvasLayer/Death_panel/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "Ennemis tués : " + str(Global.kill_count)
	$CanvasLayer/Death_panel.visible = true

func button_reprendre():
	$CanvasLayer/Pause_panel.visible = false
	if $CanvasLayer/Death_panel.visible:
		$Jeu/Player.health_points = $Jeu/Player.max_health_points
		$CanvasLayer/Death_panel.visible = false # c'est pour le lore
	Global.paused = false

func button_redemarer():
	get_tree().change_scene_to_file("res://node_2d.tscn")
	Global.paused = false

func button_quitter():
	get_tree().change_scene_to_file("res://menu.tscn")
	Global.paused = false
	

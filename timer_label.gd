extends Label

var elapsed_time = 0.0

func _process(delta):
	if !Global.paused:
		elapsed_time += delta
		var seconds = int(elapsed_time) % 60
		var minutes = int(elapsed_time) / 60
		text = "%02d:%02d" % [minutes, seconds]

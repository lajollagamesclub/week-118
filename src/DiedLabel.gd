extends Label

var time: float = 0.0

func _process(delta):
	time += delta
	rect_pivot_offset = rect_size / 2
	rect_rotation = sin(time*3)*20.0
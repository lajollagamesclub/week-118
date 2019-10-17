extends AudioStreamPlayer2D

func _ready():
	play()

func _on_EnemyStreamPlayer_finished():
	queue_free()
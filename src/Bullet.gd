extends Area2D

export var bullet_speed = 1000.0

var damage = 5.0
var to_ignore: Array = []

func _physics_process(delta):
	global_position += Vector2(bullet_speed, 0).rotated(rotation)*delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("hittable") and not area in to_ignore:
		area.hit(damage)
		queue_free()
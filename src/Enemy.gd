#tool
extends Area2D

signal dead(coordinate)

const movement_fraction = 4.0

export var alien_type: int = 1 setget set_alien_type
export var min_firing_rate = 2.0
export (float) var max_firing_rate: float = 4.50
export (Curve) var firing_curve

var coordinate: Vector2 = Vector2()
var bottom = false
var health = 5.0
onready var cur_fire_timer_length: float = max_firing_rate
var cur_fire_timer: float = 0.0

func _ready():
	randomize()
	if Engine.editor_hint:
		set_process(false)
	else:
		set_process(true)

func _process(delta):
	cur_fire_timer += delta
	if cur_fire_timer >= cur_fire_timer_length:
		cur_fire_timer = 0.0
		var height_index = global_position.y/ProjectSettings.get_setting("display/window/size/width")
		var fire_influence = firing_curve.interpolate(height_index)
		var lerped_max = lerp(max_firing_rate, min_firing_rate, fire_influence)
		cur_fire_timer_length = rand_range(0.0, lerped_max)
		if bottom:
			var cur_bullet = preload("res://Bullet.tscn").instance()
			get_parent().add_child(cur_bullet)
			cur_bullet.to_ignore.append(self)
			cur_bullet.rotation = deg2rad(90)
			cur_bullet.global_position = global_position
			$AnimatedSprite.play("attack")
			$AnimatedSprite.frame = 0
			
func set_alien_type(in_alien_type):
	if in_alien_type > 5 or in_alien_type < 1:
		printerr("Invalid alien type ", in_alien_type, ", must be 1-5 inclusive")
		return
	alien_type = in_alien_type
	$AnimatedSprite.frames = load(str("res://aliens/", alien_type, "/frames.tres"))

func hit(damage):
	health -= damage
	if health <= 0.0:
		emit_signal("dead", coordinate)
		GameState.score += 1
		queue_free()
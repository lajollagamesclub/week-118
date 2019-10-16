tool
extends Area2D

signal dead(coordinate)

const movement_fraction = 4.0

export var alien_type: int = 1 setget set_alien_type

var coordinate: Vector2 = Vector2()

func set_alien_type(in_alien_type):
	if in_alien_type > 5 or in_alien_type < 1:
		printerr("Invalid alien type ", in_alien_type, ", must be 1-5 inclusive")
		return
	alien_type = in_alien_type
	$AnimatedSprite.frames = load(str("res://aliens/", alien_type, "/frames.tres"))
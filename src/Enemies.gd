tool
extends Node2D

export (PackedScene) var enemy_scene
export (float) var enemy_square_length setget set_enemy_square_length
export (int) var enemy_dimensions setget set_enemy_dimensions

var enemies_generated: bool = false

func _ready():
	if Engine.editor_hint:
		set_process(false)
	else:
		set_process(true)

func generate_enemies():
	if enemies_generated:
		return
	enemies_generated = true
	
func remove_enemies():
	enemies_generated = false
	for c in get_children():
		c.queue_free()

func next_round():
	remove_enemies()
	generate_enemies()

func set_enemy_square_length(new_enemy_square_length):
	enemy_square_length = new_enemy_square_length
	remove_enemies()
	generate_enemies()

func set_enemy_dimensions(new_enemy_dimensions):
	enemy_dimensions = new_enemy_dimensions
	remove_enemies()
	generate_enemies()
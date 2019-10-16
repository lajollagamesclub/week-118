tool
extends Node2D

export (PackedScene) var enemy_scene
export (int) var enemy_square_length setget set_enemy_square_length
export (Vector2) var enemy_dimensions setget set_enemy_dimensions
export var movement_time = 0.3

var cur_move_counter = 0.0
var direction = 1.0
onready var horizontal_length: int = int(enemy_dimensions.y)

var enemies = [[]]

func _process(delta):
	cur_move_counter += delta
	if cur_move_counter >= movement_time:
		for enemy in get_children():
			enemy.move(direction)
		cur_move_counter = 0.0

func _ready():
	if Engine.editor_hint:
		set_process(false)
	else:
		set_process(true)

func generate_enemies():
	enemies.clear()
	for row in range(int(enemy_dimensions.x)):
		enemies.append([])
		for column in range(int(enemy_dimensions.y)):
			var cur_enemy = enemy_scene.instance()
			add_child(cur_enemy)
			cur_enemy.global_position = Vector2(column * enemy_square_length, row * enemy_square_length) + Vector2(enemy_square_length, enemy_square_length)/2
			cur_enemy.alien_type = 6 - (int(row) + 1)
			cur_enemy.coordinate = Vector2(row, column)
			cur_enemy.connect("dead", self, "_on_enemy_death")
			enemies[row].append(cur_enemy)

func _on_enemy_death(coordinate):
	enemies[coordinate.x][coordinate.y] = null

func remove_enemies():
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
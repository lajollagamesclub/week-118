tool
extends Node2D

export (PackedScene) var enemy_scene
export (int) var enemy_square_length setget set_enemy_square_length
export (Vector2) var enemy_dimensions setget set_enemy_dimensions
export var movement_time = 0.3

var cur_move_counter = 0.0
var direction = 1.0
var right_missing: int = 0
var left_missing: int = 0

var enemies = [[]]

func _ready():
	if Engine.editor_hint:
		set_process(false)
	else:
		set_process(true)

func is_column_empty(column_index: int) -> bool:
	for r in enemies:
		if r[column_index] != null:
			return false
	return true

func _process(delta):
#	cur_move_counter += delta
#	if cur_move_counter >= movement_time:
	# update left/right missing index
	var right_column_index = int(enemy_dimensions.y) - 1 - right_missing
	var left_column_index = left_missing
	if is_column_empty(right_column_index):
		right_missing += 1
	if is_column_empty(left_column_index):
		left_missing += 1

	# apply direction based on missing columns
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	if global_position.x + float(enemy_square_length * (int(enemy_dimensions.y) - right_missing)) > screen_width:
		direction = -1.0

	if global_position.x + float(enemy_square_length * left_missing) < 0:
		direction = 1.0

	# apply direction
	global_position.x += 100.0*delta*direction

	cur_move_counter = 0.0

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
	for r in range(enemies.size()):
		for c in range(enemies[0].size()):
			if enemies[r][c] != null:
				return
	next_round()

func remove_enemies():
	for c in get_children():
		c.queue_free()

func next_round():
	remove_enemies()
	left_missing = 0
	right_missing = 0
	direction = 1.0
	global_position = Vector2()
	generate_enemies()

func set_enemy_square_length(new_enemy_square_length):
	enemy_square_length = new_enemy_square_length
	remove_enemies()
	generate_enemies()

func set_enemy_dimensions(new_enemy_dimensions):
	enemy_dimensions = new_enemy_dimensions
	remove_enemies()
	generate_enemies()
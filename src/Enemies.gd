extends Node2D

const down_amount_divisor = 4.0

export (PackedScene) var enemy_scene
export (int) var enemy_square_length setget set_enemy_square_length
export (Vector2) var enemy_dimensions = Vector2(5, 5) setget set_enemy_dimensions
export var movement_time = 0.3

var cur_move_counter = 0.0
var direction = 1.0
var right_missing: int = 0
var left_missing: int = 0
var progression: int = 0
var speed = 100.0

var enemies = [[]]

func _ready():
	if Engine.editor_hint:
		set_process(false)
	else:
		set_process(true)
	remove_enemies()
	generate_enemies()

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
	if global_position.x + float(enemy_square_length * (int(enemy_dimensions.y) - right_missing)) > screen_width or \
	global_position.x + float(enemy_square_length * left_missing) < 0:
		direction *= -1
		global_position.y += enemy_square_length/down_amount_divisor
		if global_position.y >= ProjectSettings.get_setting("display/window/size/height"):
			GameState.player_dead()
		speed += float(GameState.level)*3.0

	# apply direction
	global_position.x += speed*delta*direction

	cur_move_counter = 0.0

func generate_enemies():
	enemies.clear()
	for row in range(int(enemy_dimensions.x)):
		enemies.append([])
		for column in range(int(enemy_dimensions.y)):
			var cur_enemy = enemy_scene.instance()
			call_deferred("add_child", cur_enemy)
			cur_enemy.global_position = Vector2(column * enemy_square_length, row * enemy_square_length) + Vector2(enemy_square_length, enemy_square_length)/2
			cur_enemy.alien_type = 6 - (int(row) + 1)
			cur_enemy.coordinate = Vector2(row, column)
			cur_enemy.connect("dead", self, "_on_enemy_death")
			enemies[row].append(cur_enemy)
	for bottom_enemy in enemies[int(enemy_dimensions.x) - 1]:
		bottom_enemy.bottom = true

func _on_enemy_death(coordinate):
	enemies[coordinate.x][coordinate.y] = null
	
	if no_more_enemies():
		next_round()
	
	for c in range(enemies[0].size()):
		for r in range(enemies.size() - 1):
			if enemies[r][c] != null and enemies[r+1][c] == null:
				enemies[r][c].bottom = true

func no_more_enemies() -> bool:
	for r in range(enemies.size()):
		for c in range(enemies[0].size()):
			if enemies[r][c] != null:
				return false
	return true

func remove_enemies():
	for c in get_children():
		c.queue_free()

func next_round():
	GameState.level += 1
	remove_enemies()
	left_missing = 0
	right_missing = 0
	direction = 1.0
	global_position = Vector2()
	generate_enemies()

func set_enemy_square_length(new_enemy_square_length):
	enemy_square_length = new_enemy_square_length
	if Engine.editor_hint:
		remove_enemies()
		generate_enemies()

func set_enemy_dimensions(new_enemy_dimensions):
	enemy_dimensions = new_enemy_dimensions
	if Engine.editor_hint:
		remove_enemies()
		generate_enemies()
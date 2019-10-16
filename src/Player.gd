extends Area2D

export var player_velocity = 500.0
export var bullet_cooldown = 0.2

var health: int = 5 setget set_health
var cur_bullet_recharge_time: float = 0.0

func _process(delta):
	var horizontal: int = int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left"))
	
	global_position.x += horizontal*player_velocity*delta
	global_position.x = clamp(global_position.x,  $Sprite.texture.get_size().x/2, ProjectSettings.get_setting("display/window/size/width") - $Sprite.texture.get_size().x/2)
	
	if Input.is_action_pressed("g_fire") and cur_bullet_recharge_time >= bullet_cooldown:
		cur_bullet_recharge_time = 0.0
		var cur_bullet = preload("res://Bullet.tscn").instance()
		cur_bullet.to_ignore.append(self)
		cur_bullet.global_position = global_position
		cur_bullet.rotation = deg2rad(-90)
		get_parent().add_child(cur_bullet)

	cur_bullet_recharge_time += delta

func hit(damage: float):
	self.health -= damage

func set_health(new_health):
	if new_health <= 0:
		GameState.player_dead()
extends Area2D

export var player_velocity = 500.0

func _process(delta):
	var horizontal: int = int(Input.is_action_pressed("g_right")) - int(Input.is_action_pressed("g_left"))
	
	global_position.x += horizontal*player_velocity*delta
	global_position.x = clamp(global_position.x,  $Sprite.texture.get_size().x/2, ProjectSettings.get_setting("display/window/size/width") - $Sprite.texture.get_size().x/2)
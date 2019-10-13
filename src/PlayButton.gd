extends Button

export (String, FILE, "*.tscn") var target_scene = ""

func _on_TravelButon_pressed():
	if target_scene != "":
		get_tree().change_scene(target_scene)
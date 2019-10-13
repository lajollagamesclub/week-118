extends Button

func _ready():
	if OS.get_name() == "HTML5":
		visible = false

func _on_QuitButton_pressed():
	get_tree().quit()
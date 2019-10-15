extends Node

var score: int = 0
var alive: bool = true

func player_dead():
	alive = false
	get_tree().change_scene("res://DeathScreen.tscn")

func game_start():
	score = 0
	alive = true
	get_tree().change_scene("res://Main.tscn")
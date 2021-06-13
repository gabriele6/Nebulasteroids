extends Label

var scene = preload("res://World.tscn")

func callback():
	get_tree().paused = false
	get_tree().change_scene("res://World.tscn")

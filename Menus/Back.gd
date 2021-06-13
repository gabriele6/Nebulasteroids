extends Label

func callback():
	get_tree().paused = false
	get_tree().change_scene("res://Menus/MainMenu.tscn")

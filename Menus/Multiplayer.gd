extends Label

#var scene = preload("res://Levels/Multi_1.tscn")

func callback():
	#get_tree().change_scene("res://Menus/SettingsMenu.tscn")
	$"../../../../../Controls".rect_global_position=Vector2(0,0)
	$"../../../../../Controls".visible=true

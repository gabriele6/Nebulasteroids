extends Label

#var scene = preload("res://Menus/SettingsMenu.tscn")

func callback():
	#get_tree().change_scene("res://Menus/SettingsMenu.tscn")
	$"../../../../../SettingsMenu".rect_global_position=Vector2(0,0)
	$"../../../../../SettingsMenu".visible=true

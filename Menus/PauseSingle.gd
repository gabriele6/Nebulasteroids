extends Control

func pause_pressed():
	get_tree().paused = true
	self.visible = true

func resume_pressed():
	get_tree().paused = false
	self.visible = false

func _on_Settings_pressed():
	#get_tree().change_scene("res://Menus/SettingsMenu.tscn")
	
	#rendi visibile la finestra settings
	if !$SettingsMenu.visible:
		$SettingsMenu.visible = !$SettingsMenu.visible
	
func _on_Restart_pressed():
	resume_pressed()

func _on_Main_menu_pressed():
	if !$SettingsMenu.visible:
		get_tree().paused = false
		get_tree().change_scene("res://Menus/MainMenu.tscn")

func _on_Quit_pressed():
	if !$SettingsMenu.visible:
		get_tree().quit()


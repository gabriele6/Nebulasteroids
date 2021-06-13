extends Control

signal settings_menu_closed
onready var _bus := AudioServer.get_bus_index("Master")

var keybinds
var settings
var buttons = {}
var _music
var _sounds

func _ready():
	var music_value = db2linear(AudioServer.get_bus_volume_db(_bus))
	if music_value == 1:
		$Panel/MusicButton.pressed = true
	else:
		$Panel/MusicButton.pressed = false
	$Panel/FullScreenButton.pressed = OS.window_fullscreen

func _on_FullScreenButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_Back_button_up():
	self.visible=false
	emit_signal("settings_menu_closed")

func _on_MusicButton_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_volume_db(_bus, linear2db(1))
	else:
		AudioServer.set_bus_volume_db(_bus, linear2db(0))

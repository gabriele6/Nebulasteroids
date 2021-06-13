extends Control

signal controls_menu_closed

var keybinds
var settings
var buttons = {}
var _music
var _sounds

func _ready():
	pass

func _on_FullScreenButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_Back_button_up():
	self.visible=false
	emit_signal("controls_menu_closed")

func _on_MusicButton_toggled(button_pressed):
	pass

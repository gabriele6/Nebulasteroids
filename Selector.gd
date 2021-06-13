extends ReferenceRect

const pull = preload("res://Effects/Pull.tscn")
onready var SettingsMenu = $"../../../../../SettingsMenu"
onready var Controls = $"../../../../../Controls"
onready var current_menu: Node = get_parent()

var entries = []
var index
var n_options = 4
var selected = false

var offsetX = 0
var offsetY = 2
var effect_delay = 0.4
var t = 0

func create_particle():
	var pe = pull.instance()
	pe.get_node(".").set_emitting(true)
	pe.position = $"../Pull".global_position
	get_tree().get_root().add_child(pe)

func _ready():
	t = 0
	entries = []
	for entry in current_menu.get_children():
		if entry.visible and entry is Label:
			entries.append(entry)
	if entries.size() > 0:
		set_selection(0)
	SettingsMenu.connect("settings_menu_closed", self, "_on_SettingsMenu_settings_menu_closed")
	Controls.connect("controls_menu_closed", self, "_on_SettingsMenu_settings_menu_closed")

func set_selection(new_index):
	if 0 <= new_index and new_index < entries.size() and new_index != self.index:
		self.index = new_index
		var selected_node = entries[index]
		self.rect_position = Vector2(
			selected_node.rect_position.x + offsetX,
			selected_node.rect_position.y + offsetY)
		self.rect_size = selected_node.rect_size
		
		var tween_node = get_node("../Pull/Tween")
#		tween_node.interpolate_property($"../Pull", "position", $"../Pull".position, self.rect_position + Vector2(50,30), 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
#		tween_node.start()

func _physics_process(delta):
	# do stuff only if settings aren't up
	if !SettingsMenu.visible:
		# animate the selector
		t+=delta
		if t>effect_delay:
#			create_particle()
			t-=effect_delay
		if !SettingsMenu.visible:
			# check the input
			if Input.is_action_just_pressed("ui_up"):
				if index > 0:
					set_selection(index - 1)
					$MenuMovement.play()
			if Input.is_action_just_pressed("ui_down"):
				if index < entries.size()-1:
					set_selection(index + 1)
					$MenuMovement.play()
					#$"../../../../../SettingsMenu"
			if Input.is_action_just_pressed("ui_accept"):
				$MenuSelection.play()
				yield(get_tree().create_timer(0.5), "timeout") 
				entries[index].callback()
				# TODO:add selection animation here 
		
# processing mouse clicks and movements
func _on_MenuEntries_gui_input(event):
	if !SettingsMenu.visible and !selected:
		if event is InputEventMouseMotion:
			var mouse_pos = get_parent().get_local_mouse_position()
			var new_index = floor(mouse_pos.y/52)
			if new_index>n_options-1:
				new_index = n_options-1
			if new_index!=index:
				self.set_selection(new_index)
				$MenuMovement.play()
		if event is InputEventMouseButton:
			$MenuSelection.play()
			selected = true
			yield(get_tree().create_timer(0.5), "timeout") 
			entries[index].callback()



func _on_SettingsMenu_settings_menu_closed():
	selected = false

# TODO: place the items properly
func _on_ColorRect_resized():
	pass # Replace with function body.

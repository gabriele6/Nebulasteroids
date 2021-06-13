extends KinematicBody2D

export var speed = 100
var base_speed = 100
var dash_speed = 300

var velocity = Vector2.ZERO

signal player_hit

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("dash"):
		dash()
	velocity = velocity.normalized() * speed
	return Input.is_action_just_pressed("click")

func dash():
	self.speed = self.dash_speed
	$DashTimer.start()
#	self.current_dash_ghost = 0
#	$GhostTimer.start()
#	$Audio/Dash.play()
	
func _physics_process(delta):
	var clicked = get_input()
	if clicked:
#		var mouse_pos = get_global_mouse_position()
#		print (mouse_pos)
		pass
	velocity = move_and_slide(velocity)
	
	# check screen boundaries
	check_boundaries()

func check_boundaries():
	var vp = get_viewport_rect()
	var camera = get_parent().get_node("Camera")
	if position.x<0 + $Collision.shape.radius:
		position.x = 0 + $Collision.shape.radius
	if position.y<0 + $Collision.shape.radius:
		position.y=0 + $Collision.shape.radius
	if position.x>(vp.size * camera.zoom).x - $Collision.shape.radius:
		position.x = (vp.size * camera.zoom).x - $Collision.shape.radius
	if position.y>(vp.size * camera.zoom).y - $Collision.shape.radius:
		position.y=(vp.size * camera.zoom).y - $Collision.shape.radius

func _on_DashTimer_timeout():
	self.speed = self.base_speed

func on_hit():
	emit_signal("player_hit")

func _on_Hitbox_body_entered(body):
	if "Line" in body.name:
		pass
	elif "Partner" in body.name:
		pass
	elif "Player" in body.name:
		pass
	else:
		on_hit()

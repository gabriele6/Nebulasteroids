extends KinematicBody2D

export var speed = 120

var velocity = Vector2.ZERO
var target_pos = Vector2.ZERO
var acceleration = 0.1
var friction = 0.05

var pos_timer = 5.0
var pos_timer_p = 0.0
var rand_bounds = Vector2(0.25,1.0)

signal partner_hit

func _ready():
	pick_random_position()

func _physics_process(delta):

	if(get_input()):
		target_pos = get_global_mouse_position()
	if target_pos!=null:
		# if I'm close to the position, slow down
		if abs(target_pos.x-position.x) + abs(target_pos.y-position.y) < 20:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		# else speed up
		else:
			velocity = (target_pos - position).normalized()
			velocity = velocity.linear_interpolate((target_pos - position).normalized(), acceleration) 
		position += velocity*delta*speed
		
		pos_timer_p += delta
		if(abs(target_pos.x-position.x) + abs(target_pos.y-position.y) < 3):
			target_pos=null
	move_and_slide(Vector2.ZERO)
	# pick a new target position if enough time has passed
#	if pos_timer_p > pos_timer:
#		pos_timer_p = 0.0
#		pick_random_position()
	
	# check screen boundaries to see if I'm out of the screen
	check_boundaries()

func pick_random_position():
		var vp = get_viewport_rect()
		var camera = get_parent().get_node("Camera")
		var x = (vp.size * camera.zoom).x
		var y = (vp.size * camera.zoom).y
		target_pos = Vector2(randi()%int(x*rand_bounds.x), randi()%int(y*rand_bounds.y))
		return target_pos

func check_boundaries():
	var vp = get_viewport_rect()
	var camera = get_parent().get_node("Camera")
	if position.x<0 + $Collision.shape.radius:
		position.x = 0 + $Collision.shape.radius
	if position.y<0 + $Collision.shape.radius:
		position.y = 0 + $Collision.shape.radius
	if position.x>(vp.size * camera.zoom).x - $Collision.shape.radius:
		position.x = (vp.size * camera.zoom).x - $Collision.shape.radius
	if position.y>(vp.size * camera.zoom).y - $Collision.shape.radius:
		position.y=(vp.size * camera.zoom).y - $Collision.shape.radius

func get_input():
	return Input.is_action_just_pressed("click")

func on_hit():
	emit_signal("partner_hit")

func _on_Hitbox_body_entered(body):
	if "Line" in body.name:
		pass
	elif "Partner" in body.name:
		pass
	elif "Player" in body.name:
		pass
	else:
		on_hit()

extends KinematicBody2D

signal asteroid_destroyed
signal asteroid_passed

var trail = preload("res://Effects/Trail.tscn")
var head = preload("res://Effects/Head.tscn")
var explosion = preload("res://Effects/Scatter.tscn")
var shockwave = preload("res://Effects/Shockwave.tscn")

var min_speed = 20
export var speed = 80.0
export var rotation_speed = 2.0

var trail_spawn = 0.3
var trail_time = 0.0

var velocity = Vector2.ZERO

func _ready():
	# randomizing the rotation speed
	randomize()
	rotation_speed*=randf() + 0.5
	# invert rotation
	if randi()%2==0:
		rotation_speed*=-1.0
	
	# randomizing the speed
	speed = min_speed + speed * randf()

func _physics_process(delta):
	# emit particles
	trail_time+=delta
	if trail_time>trail_spawn*(1.0-min(log(speed)/log(100), 0.8)):
		trail_time-=trail_spawn*(1.0-min(log(speed)/log(100), 0.8))
		create_head()
		create_trail()
	# move
	self.rotation += delta*rotation_speed
	self.position.x -= speed * delta

	if position.x<0-20:
		emit_signal("asteroid_passed")
		queue_free()

func create_trail():
	var tr = trail.instance()
	tr.position = self.position
	get_parent().add_child(tr)
	tr.emitting = true

func create_head():
	var tr = head.instance()
	tr.position = self.position-Vector2(10,0)
	get_parent().add_child(tr)
	tr.emitting = true

func create_shockwave():
	var sw = shockwave.instance()
	get_parent().add_child(sw)
	sw.get_node("Shockwave").get_material().set_shader_param("center", Vector2((self.get_global_transform_with_canvas().origin/ get_viewport_rect().size).x, 1.0-(self.get_global_transform_with_canvas().origin/ get_viewport_rect().size).y))
	var tw = sw.get_node("Tween")
	tw.interpolate_property(sw.get_node("Shockwave").get_material(), "shader_param/size", 0, 2, 1.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tw.start()
	
func play_explosion_sound():
	get_parent().get_node("Explosion").play()
	
func flash():
	$Whiten.interpolate_property(self, "self_modulate", self.self_modulate, Color(1,1,1,1), 0.05, Tween.TRANS_QUAD, Tween.EASE_OUT_IN)
	$Whiten.interpolate_property(self, "modulate", self.modulate, Color(1,1,1,1), 0.05, Tween.TRANS_QUAD, Tween.EASE_OUT_IN)
	$Whiten.start()

func create_explosion():
	var tr = explosion.instance()
	tr.position = self.position
	get_parent().add_child(tr)
	tr.emitting = true
	
func destroy():
	flash()
	play_explosion_sound()
	create_explosion()
	yield($Whiten, "tween_all_completed")
	if speed>80:
		create_shockwave()
	emit_signal("asteroid_destroyed")
	queue_free()

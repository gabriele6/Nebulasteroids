extends Node

var enemy = preload("res://Enemy.tscn")
var asteroid1 = preload("res://Asteroid.tscn")
var asteroid2 = preload("res://Asteroid2.tscn")

var spawn_time = 1.0
var spawn_passed = 0.0
var asteroids_destroyed = 0
var asteroids_passed = 0
var max_asteroids = 10

var score = 0
var passed_score = 40
var destroyed_score = 10

func _input(event):
	if Input.is_action_pressed("pause"):
		var pause = $PauseSingle.get_node("Pause")
		if 	get_tree().paused and pause.visible:
			pause.resume_pressed()
		elif !get_tree().paused and !pause.visible:
			pause.pause_pressed()

func _ready():
	randomize()
	$Player.connect("player_hit", self, "_on_Player_hit")
	$Partner.connect("partner_hit", self, "_on_Partner_hit")

func _physics_process(delta):
	$Link.clear_points()
	$Link.add_point($Player.position)
	$Link.add_point($Partner.position)
	$Link/LinkArea/Shape.shape.set_a($Player.position)
	$Link/LinkArea/Shape.shape.set_b($Partner.position)
	
	# align the glow to the link
	$Link/RayGlow.position = ($Link.points[1] + $Link.points[0]) *0.5
	var dist = $Partner.position.distance_to($Player.position)
	$Link/RayGlow.emission_rect_extents.x = dist*2.5
	$Link/RayGlow.rotation = $Player.position.angle_to_point($Partner.position)
	
	# debug: print number of particles
#	var count = 0
#	for n in get_children():
#		if "rail" in n.name or "ead" in n.name:
#			count+=1
#	print(count)
	
	# spawning asteroids
	spawn_passed += delta
	if spawn_passed > spawn_time:
		spawn_asteroid()
		spawn_passed = 0

func spawn_asteroid():
	var ast = asteroid2.instance()
	ast.position = Vector2(400, randi()%180)
	ast.scale = Vector2(0.2, 0.2)
	self.add_child(ast)
	ast.connect("asteroid_destroyed", self, "_on_Asteroid_destroyed")
	ast.connect("asteroid_passed", self, "_on_Asteroid_passed")

func _on_LinkArea_body_entered(body):
	if "Player" in body.name or "Partner" in body.name:
		pass
	else:
		body.destroy()

func _on_Player_hit():
	print("Player hit!")
	
func _on_Partner_hit():
	print("Partner hit!")
	
func _on_Asteroid_destroyed():
	asteroids_destroyed+=1
	$Camera/ScreenShake.start(0.2, 30, 3,  0)
	score+=destroyed_score
	print("Score: %d" %score)
	
func _on_Asteroid_passed():
	asteroids_passed+=1
	score-=passed_score
	print("Score: %d" %score)
	if asteroids_passed == max_asteroids:
		var go = $GameOver.get_node("GO")
		go.set_score(score)
		go.pause_pressed()


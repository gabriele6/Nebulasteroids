extends KinematicBody2D

export var speed = 60

var velocity = Vector2.ZERO

func _physics_process(delta):
	pass

func destroy():
	queue_free()

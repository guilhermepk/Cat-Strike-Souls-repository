extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 100
var limit_spd = 100
var desac = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if motion.x > limit_spd:
		motion.x = limit_spd
	elif motion.x < -limit_spd:
		motion.x = -limit_spd
		
	if motion.y > limit_spd:
		motion.y = limit_spd
	elif motion.y < -limit_spd:
		motion.y = -limit_spd
		
	motion.x += spd
	
	
	move_and_slide(motion)

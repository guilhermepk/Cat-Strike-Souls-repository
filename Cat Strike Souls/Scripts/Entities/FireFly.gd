extends KinematicBody2D

var on = false
var blinkSpd
var initialEnergy = 0.5

var framesPassed = 0
var secondsPassed = 0

var motion = Vector2.ZERO

var random = RandomNumberGenerator.new()
var axis
var spd
var limitSpd = 20

func _ready():
	random.randomize()
	
	# 0.008
	blinkSpd = random.randf_range(0.002, 0.01)
	
	$Light2D.energy = initialEnergy
	
	axis = random.randi_range(1, 2)
	spd = random.randf_range(-limitSpd, limitSpd)
	while spd < 5 and spd > -5:
		spd = random.randf_range(-limitSpd, limitSpd)
	motion.x = spd
	motion.y = spd
	
func _process(delta):
	#y -100 a 1400
	#x -800 a 800
	if position.x <= -800:
		motion.x = limitSpd
	elif position.x >= 800:
		motion.x = -limitSpd	
	if position.y <= -100:
		motion.y = limitSpd
	elif position.y >= 1400:
		motion.y = -limitSpd
	
	framesPassed += 1
	if framesPassed >= 60:
		framesPassed = 0
		secondsPassed += 1
		
	if secondsPassed >= 5:
		secondsPassed = 0
		axis = random.randi_range(1, 2)
		spd = random.randf_range(-limitSpd, limitSpd)
		while spd < 5 and spd > -5:
			spd = random.randf_range(-limitSpd, limitSpd)
		if axis == 1:
			motion.x = spd
		elif axis == 2:
			motion.y = spd
	
	if !on and $Light2D.energy < 1.5:
		$Light2D.energy += blinkSpd
	else:
		on = true
		
	if on:
		if $Light2D.energy > initialEnergy:
			$Light2D.energy -= blinkSpd
		else:
			on = false
			
	move_and_slide(motion)

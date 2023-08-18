extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 50
var limit_spd = 100
var desac = 10

var rng = RandomNumberGenerator.new()
var dir
var savedDir

# Called when the node enters the scene tree for the first time.
func _ready():
	dir = rng.randi_range(1, 8)

func _process(delta):
	if motion.x > limit_spd:
		motion.x = limit_spd
	elif motion.x < -limit_spd:
		motion.x = -limit_spd
		
	if motion.y > limit_spd:
		motion.y = limit_spd
	elif motion.y < -limit_spd:
		motion.y = -limit_spd
		
		
	match dir:
		1:
			motion.y -= spd
		2:
			motion.y -= spd
			motion.x += spd
		3:
			motion.x += spd
		4:
			motion.x += spd
			motion.y += spd
		5:
			motion.y += spd
		6:
			motion.x -= spd
			motion.y += spd
		7:
			motion.x -= spd
		8:
			motion.x -= spd
			motion.y -= spd
	
	#move_and_slide(motion)


func _on_GolemArea2D_body_entered(body):
	if body.name == 'Player':
		print('Player encostou no Boss')
	else:
		print('Boss encostou em ', body.name, ' ')
		savedDir = dir
		while dir == savedDir:
			dir = rng.randi_range(1, 8)


func _on_Influence_body_entered(body):
	if body.name == 'Player':
		$AnimatedSprite.play("attack")


func _on_Influence_body_exited(body):
	if body.name == 'Player':
		$AnimatedSprite.play('idle')

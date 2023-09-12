extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 50
var limit_spd = 100
var desac = 10

var rng = RandomNumberGenerator.new()

var follow
var player

var playerInInfluence = false
var playerNearby = false
var playerInArm = false
var playerTooNear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$AnimatedSprite.play("idle")

func _process(delta):
	if motion.x > limit_spd:
		motion.x = limit_spd
	elif motion.x < -limit_spd:
		motion.x = -limit_spd
		
	if motion.y > limit_spd:
		motion.y = limit_spd
	elif motion.y < -limit_spd:
		motion.y = -limit_spd
	
	if follow and !player.inBox:
		followPlayer(player)
	else:
		motion.x = 0
		motion.y = 0
		
	if playerInArm and $AnimatedSprite.animation == 'attack' and $AnimatedSprite.frame == 7:
		player.alive = false
	
	var animationTime = $AnimationPlayer.current_animation_position
	if animationTime >= 1.25 and animationTime <= 1.75:
		if playerNearby:
			player.alive = false
	
	if playerTooNear and player.alive:
		$AnimatedSprite.play("shine")
		$AnimationPlayer.play("shineAttack")
	elif playerNearby and player.alive:
		$AnimatedSprite.play("attack")
	elif !playerInInfluence:
		$AnimatedSprite.play("asteroid")
		if $AnimatedSprite.frame == 7:
			$AnimatedSprite.playing = false 
	else:
		$AnimatedSprite.play("idle")
	
	move_and_slide(motion)

func followPlayer(player):
	var playerX = player.position.x
	var playerY = player.position.y
	var x = position.x
	var y = position.y
	
	if playerX > x+35*scale.x:
		motion.x += spd
		$AnimatedSprite.flip_h = false
		$Arm/CollisionPolygon2D.scale.x = 1
		$Arm/CollisionPolygon2D.position.x = -3
	elif playerX < x-35*scale.x:
		motion.x -= spd
		$AnimatedSprite.flip_h = true
		$Arm/CollisionPolygon2D.scale.x = -1
		$Arm/CollisionPolygon2D.position.x = 3
	else:
		motion.x = 0
	
	if playerY > y+5*scale.y:
		motion.y += spd
	elif playerY < y-5*scale.y:
		motion.y -= spd
	else:
		motion.y = 0
		#motion.y += rng.randi_range()
	
	var xInside
	var yInside
	if playerX < x+30*scale.x and playerX > x-30*scale.x:
		xInside = true
	if playerY < y+30*scale.x and playerY > y-30*scale.x:
		yInside = true
		
	if xInside and yInside:
		playerTooNear = true
	else:
		playerTooNear = false

func _on_GolemArea2D_body_entered(body):
	print('Boss encostou em ', body.name)

func _on_Influence_body_entered(body):
	if body.name == 'Player':
		print('Player entrou na área de influência')
		player = body
		print(player)
		follow = true
		playerInInfluence = true


func _on_Influence_body_exited(body):
	if body.name == 'Player':
		print('Player saiu da área de influência')
		follow = false
		playerInInfluence = false
		


func _on_InfluenceNearby_body_entered(body):
	if body.name == 'Player':
		print('Player entrou na área próxima')
		playerNearby = true


func _on_InfluenceNearby_body_exited(body):
	if body.name == 'Player':
		print('Player saiu da área próxima')
		playerNearby = false
		$AnimatedSprite.play('idle')


func _on_Arm_body_entered(body):
	if body.name == 'Player':
		playerInArm = true
		player = body


func _on_Arm_body_exited(body):
	if body.name == 'Player':
		playerInArm = false

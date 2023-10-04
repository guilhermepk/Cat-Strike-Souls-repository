extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 15
var limit_spd = 150
var desac = 5

var rng = RandomNumberGenerator.new()

var follow
var player

var playerInInfluence = false
var playerNearby = false
var playerInArm = false
var playerTooNear = false

var sleeping = true
var stunned = false

func _ready():
	rng.randomize()
	$AnimatedSprite.play("wake_up")
	$AnimatedSprite.playing = false
	$AnimatedSprite.frame = 0

func _process(delta):
	if motion.x > limit_spd:
		motion.x = limit_spd
	elif motion.x < -limit_spd:
		motion.x = -limit_spd
		
	if motion.y > limit_spd:
		motion.y = limit_spd
	elif motion.y < -limit_spd:
		motion.y = -limit_spd
	
	if follow and !player.inBox and !sleeping and !stunned:
		followPlayer(player)
	else:
		motion.x = 0
		motion.y = 0
		
	if playerInArm and $AnimatedSprite.animation == 'attack' and $AnimatedSprite.frame == 7:
		player.alive = false
	
	
	if $AnimationPlayer.current_animation == 'shineAttack':
		var animationTime = $AnimationPlayer.current_animation_position
		if animationTime >= 1.25 and animationTime <= 1.75:
			if playerNearby and !player.inBox:
				player.alive = false
			stun_golem()
	
	if sleeping and playerInInfluence:
		wakeUp()
	elif !sleeping:
		if playerTooNear and player.alive:
			$AnimatedSprite.play("shine")
			player.get_node('HUD/Warning').visible = true
			yield(get_tree().create_timer(1), "timeout")
			$AnimationPlayer.play("shineAttack")
		elif playerNearby and player.alive:
			$AnimatedSprite.play("attack")
#		elif !playerInInfluence:
#			$AnimatedSprite.play("asteroid")
#			if $AnimatedSprite.frame == 7 and $AnimatedSprite.animation == 'asteroid':
#				$AnimatedSprite.playing = false 
		else:
			$AnimatedSprite.play("idle")
	
	move_and_slide(motion)

func stun_golem():
	stunned = true
	yield(get_tree().create_timer(1), "timeout")
	stunned = false
	player.get_node('HUD/Warning').visible = false

func wakeUp():
	$AnimatedSprite.play("wake_up")
	$AnimatedSprite.playing = true
	var cur_anim = $AnimatedSprite.animation
	var anim_spd = $AnimatedSprite.frames.get_animation_speed(cur_anim)
	var anim_frames = $AnimatedSprite.frames.get_frame_count(cur_anim)
	var animTime = anim_frames / anim_spd
	
	yield(get_tree().create_timer(animTime), "timeout")
	sleeping = false

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
	#print('Boss encostou em ', body.name)
	pass

func _on_Influence_body_entered(body):
	if body.name == 'Player':
		#print('Player entrou na área de influência')
		player = body
		#print(player)
		follow = true
		playerInInfluence = true


func _on_Influence_body_exited(body):
	if body.name == 'Player':
		#print('Player saiu da área de influência')
		#follow = false
		playerInInfluence = false
		


func _on_InfluenceNearby_body_entered(body):
	if body.name == 'Player':
		#print('Player entrou na área próxima')
		playerNearby = true


func _on_InfluenceNearby_body_exited(body):
	if body.name == 'Player':
		#print('Player saiu da área próxima')
		playerNearby = false
		$AnimatedSprite.play('idle')


func _on_Arm_body_entered(body):
	if body.name == 'Player':
		playerInArm = true
		player = body


func _on_Arm_body_exited(body):
	if body.name == 'Player':
		playerInArm = false

extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 50
var limit_spd = 150
var desac = 10

var rng = RandomNumberGenerator.new()

var follow
var player

var playerInArm

var playerNearby

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

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
		print('Jogador atacado')
		player.alive = false
	
	if playerNearby and player.alive:
		$AnimatedSprite.play("attack")
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
		
	if playerY > y+5:
		motion.y += spd
	elif playerY < y-5:
		motion.y -= spd
	else:
		motion.y = 0

func _on_GolemArea2D_body_entered(body):
	print('Boss encostou em ', body.name)

func _on_Influence_body_entered(body):
	if body.name == 'Player':
		print('Player entrou na área de influência')
		player = body
		print(player)
		follow = true


func _on_Influence_body_exited(body):
	if body.name == 'Player':
		print('Player saiu da área de influência')
		follow = false


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

extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 50
var limit_spd = 200
var desac = 25

var movementScenes = [
	"Fase",
	"StartHall"
]

var upPressed = false
var downPressed = false
var rightPressed = false
var leftPressed = false

var inBox = false
var alive = true

onready var currentScene = get_tree().current_scene.name

onready var rectAnim = get_node('Camera2D/AnimationPlayer/Node2D/ColorRect')
onready var victoryLabel = get_node('Camera2D/AnimationPlayer/Node2D/VictoryLabel')

func _ready():
	$HUD/PauseMenu.visible = false
	$HUD/XKey.visible = false
	$HUD/Warning.visible = false
	
	rectAnim.visible = false
	rectAnim.color.a = 0
	victoryLabel.visible = false
	victoryLabel.modulate.a = 0
	
	$AnimatedSprite.play("idle")
	
	if currentScene in movementScenes:
		$HUD.visible = true
	else:
		$HUD.visible = false

func _process(delta):
	var victory = Global.victory
	
	rightPressed = true if (Input.is_action_pressed("ui_right")) else false
	leftPressed = true if (Input.is_action_pressed("ui_left")) else false
	upPressed = true if (Input.is_action_pressed("ui_up")) else false
	downPressed = true if (Input.is_action_pressed("ui_down")) else false
	
	if currentScene in movementScenes:
		if !victory:
			$Camera2D.current = true
			if motion.x > limit_spd:
				motion.x = limit_spd
			elif motion.x < -limit_spd:
				motion.x = -limit_spd
				
			if motion.y > limit_spd:
				motion.y = limit_spd
			elif motion.y < -limit_spd:
				motion.y = -limit_spd
				
			if alive:
#				if Input.is_action_just_pressed("ui_cancel"):
#					get_tree().paused = true
				if !inBox:
					##Movimentação
					if rightPressed:
						motion.x += spd
						$AnimatedSprite.flip_h = false
					elif leftPressed:
						motion.x -= spd
						$AnimatedSprite.flip_h = true
					else:
						if motion.x > 0:
							motion.x -= desac
						elif motion.x < 0:
							motion.x += desac
					
					if upPressed:
						motion.y -= spd
					elif downPressed:
						motion.y += spd
					else:
						if motion.y > 0:
							motion.y -= desac
						elif motion.y < 0:
							motion.y += desac
					if motion.x != 0 or motion.y != 0:
						$AnimatedSprite.play("run")
					else:
						$AnimatedSprite.play("idle")
				else:
					motion.x = 0
					motion.y = 0
					
					if Input.is_action_just_pressed('ui_down'):
						position.y += 25
					elif Input.is_action_just_pressed('ui_up'):
						position.y -= 25
					elif Input.is_action_just_pressed('ui_right'):
						position.x += 35
					elif Input.is_action_just_pressed('ui_left'):
						position.x -= 25
			else:
				motion.x = 0
				motion.y = 0
				$AnimatedSprite.play('die')
				if $AnimatedSprite.frame == 6:
					$AnimatedSprite.playing = false
				fade()
				yield(get_tree().create_timer(3.0), "timeout")
				print('jogador morreu')
				resetScene()
		else: # vitória
			motion.x = 0
			motion.y = 0
			$AnimatedSprite.play('idle')
			fadeVictory()
			yield(get_tree().create_timer(5.0), "timeout")
			Global.victory = false
			get_tree().change_scene("res://Scenes/VictoryScreen.tscn")
	elif !currentScene in movementScenes:
		motion.x = 0
		motion.y = 0
		$Camera2D.current = false
		
	move_and_slide(motion)

func resetScene():
	get_tree().change_scene("res://Scenes/Fase.tscn")

func fadeVictory():
	rectAnim.rect_position.x = position.x-640
	rectAnim.rect_position.y = position.y-360
	rectAnim.visible = true
	victoryLabel.rect_position.x = position.x-640
	victoryLabel.rect_position.y = position.y-108
	$Camera2D/AnimationPlayer.play("fadeVictory")

func fade():
	rectAnim.rect_position.x = position.x-640
	rectAnim.rect_position.y = position.y-360
	rectAnim.visible = true
	$Camera2D/AnimationPlayer.play("fade")

extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 25
var limit_spd = 225
var desac = 25

var timer = Timer.new()

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

var attacking = false

var currentScene

func resetScene():
	get_tree().change_scene("res://Scenes/Fase.tscn")

func attack():
	$AnimatedSprite.play("attack")
	var cur_anim = $AnimatedSprite.animation
	var anim_spd = $AnimatedSprite.frames.get_animation_speed(cur_anim)
	var anim_frames = $AnimatedSprite.frames.get_frame_count(cur_anim)
	var attackTime = anim_frames / anim_spd
	
	yield(get_tree().create_timer(attackTime), "timeout")
	attacking = false

func _ready():
	$AnimatedSprite.play("idle")
	currentScene = get_tree().current_scene.name
	
	if currentScene in movementScenes:
		$HUD.visible = true
	else:
		$HUD.visible = false

func _process(delta):
	rightPressed = true if (Input.is_action_pressed("ui_right")) else false
	leftPressed = true if (Input.is_action_pressed("ui_left")) else false
	upPressed = true if (Input.is_action_pressed("ui_up")) else false
	downPressed = true if (Input.is_action_pressed("ui_down")) else false
	
	if currentScene in movementScenes:
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
			if !inBox:
				if !attacking:
					if Input.is_key_pressed(67): # 67 = c
						attacking = true
						attack()
						
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
						
				if attacking:
					motion.x = 0
					motion.y = 0
					$AnimatedSprite.play("attack")
				elif motion.x != 0 or motion.y != 0:
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
					position.x += 40
				elif Input.is_action_just_pressed('ui_left'):
					position.x -= 40
		else:
			motion.x = 0
			motion.y = 0
			$AnimatedSprite.play('die')
			if $AnimatedSprite.frame == 6:
				$AnimatedSprite.playing = false
			$Camera2D/AnimationPlayer/ColorRect.rect_position.x = position.x-640
			$Camera2D/AnimationPlayer/ColorRect.rect_position.y = position.y-360
			$Camera2D/AnimationPlayer/ColorRect.visible = true
			$Camera2D/AnimationPlayer.play("fade")
			yield(get_tree().create_timer(3.0), "timeout")
			print('jogador morreu')
			resetScene()
			
	else:
		motion.x = 0
		motion.y = 0
		$Camera2D.current = false
		
	move_and_slide(motion)

extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 50
var limit_spd = 300
var desac = 25

var timer = Timer.new()

var movimentScenes = [
	"res://Scenes/Fase.tscn"
]

var inBox = false
var alive = true

func executeTimer(time, function):
	timer.connect("timeout", self, function)
	timer.wait_time = time
	timer.one_shot = true
	add_child(timer)
	timer.start()

func _process(delta):
	var currentScene = get_tree().current_scene.filename
	
	if currentScene in movimentScenes:
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
			if motion.x != 0 or motion.y != 0:
				$AnimatedSprite.play("run")
			else:
				$AnimatedSprite.play("idle")	
			if !inBox:
				##Movimentação
				if Input.is_action_pressed("ui_right"):
					motion.x += spd
					$AnimatedSprite.flip_h = false
				elif Input.is_action_pressed("ui_left"):
					motion.x -= spd
					$AnimatedSprite.flip_h = true
				else:
					if motion.x > 0:
						motion.x -= desac
					elif motion.x < 0:
						motion.x += desac
				
				if Input.is_action_pressed("ui_up"):
					motion.y -= spd
				elif Input.is_action_pressed("ui_down"):
					motion.y += spd
				else:
					if motion.y > 0:
						motion.y -= desac
					elif motion.y < 0:
						motion.y += desac
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
			$Camera2D/AnimationPlayer/ColorRect.rect_position = position
			$Camera2D/AnimationPlayer/ColorRect.visible = true
			$Camera2D/AnimationPlayer.play("fade")
			Timer
			
			get_tree().change_scene("res://Scenes/Fase.tscn")
			
			if $AnimatedSprite.frame == 6:
				$AnimatedSprite.playing = false
	else:
		$Camera2D.current = false
		
	move_and_slide(motion)

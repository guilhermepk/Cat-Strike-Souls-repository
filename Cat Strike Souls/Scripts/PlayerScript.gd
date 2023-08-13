extends KinematicBody2D

var motion = Vector2.ZERO
var spd = 100
var limit_spd = 300
var desac = 25

var movimentScenes = [
	"res://Scenes/Fase.tscn"
]

var inBox = false
	

func _process(delta): #Faz com que tudo rode a 60 fps
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
			
			if Input.is_key_pressed(69):
				position.x += 20
				position.y += 25
				visible = true
				inBox = false
		
	else:
		$Camera2D.current = false
	
	##Animação de correr
	if motion.x != 0 or motion.y != 0:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
	
	move_and_slide(motion)

extends CanvasLayer

onready var player = get_parent().get_parent()

var paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = get_tree().paused
		
		if player.alive:
			if !Global.victory:
				if player.currentScene in player.movementScenes:
					get_tree().paused = false if paused else true
					visible = false if visible else true

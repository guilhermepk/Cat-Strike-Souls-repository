extends Node2D

func _process(delta):
	if Input.is_key_pressed(88):
		$AnimatedSprite.play("pressed")
	else:
		$AnimatedSprite.play("unpressed")

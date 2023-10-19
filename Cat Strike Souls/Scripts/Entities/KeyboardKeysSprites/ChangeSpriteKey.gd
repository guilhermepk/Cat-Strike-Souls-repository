extends Node2D

var key

func _ready():
	$AnimatedSprite.play('unpressed')
	var name = self.name
	match name:
		'XKey':
			key = KEY_X
		'UpKey':
			key = KEY_UP
		'DownKey':
			key = KEY_DOWN
		'LeftKey':
			key = KEY_LEFT
		'RightKey':
			key = KEY_RIGHT

func _input(event):
	if event is InputEventKey:
		if event.scancode == key:
			if event.is_pressed():
				$AnimatedSprite.play("pressed")
			else:
				$AnimatedSprite.play("unpressed")

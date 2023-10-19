extends AnimationPlayer

onready var golemSprites = [
	get_node("Characters/Golem/AnimatedSprite"),
	get_node("Characters/Golem2/AnimatedSprite"),
	get_node("Characters/Golem3/AnimatedSprite")
]

func _ready():
	for sprite in golemSprites:
		sprite.flip_h = true
		sprite.play('idle')

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			if event.is_pressed():
				get_tree().change_scene("res://Scenes/StartHall.tscn")

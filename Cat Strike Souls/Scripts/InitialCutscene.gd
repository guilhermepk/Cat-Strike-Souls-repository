extends AnimationPlayer

onready var golemSprite = get_node("Golem/AnimatedSprite")
onready var golemSprite2 = get_node("Golem2/AnimatedSprite")
onready var golemSprite3 = get_node("Golem3/AnimatedSprite")

onready var golemSprites = [
	golemSprite,
	golemSprite2,
	golemSprite3
]

func _ready():
	for sprite in golemSprites:
		sprite.flip_h = true
		
	golemSprite.play('idle')
	golemSprite2.play('attack')
	golemSprite3.play('attack')

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			if event.is_pressed():
				get_tree().change_scene("res://Scenes/StartHall.tscn")

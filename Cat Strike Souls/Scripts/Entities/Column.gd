extends Node2D

var playerAround = false
var player

func _ready():
	pass

func _process(delta):
	if playerAround:
		pass


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		player = body
		print('player entrou')
		playerAround = true


func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		print('player saiu')
		playerAround = false

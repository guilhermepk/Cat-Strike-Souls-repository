extends Node2D

var player
var XKey

func _ready():
	player = get_tree().current_scene.get_node('Elements/YSort/Player')
	XKey = player.get_node('XKey')

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		XKey.visible = true

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		XKey.visible = false

extends Area2D

func _on_Door_body_entered(body):
	if body.name == 'Player':
		print('player entrou na porta')
		get_tree().change_scene("res://Scenes/Fase.tscn")

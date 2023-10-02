extends Area2D

var current_scene

func _ready():
	current_scene = get_tree().current_scene.filename
	
func _process(delta):
	pass

func _on_Door_body_entered(body):
	if body.name == 'Player':
		print('player entrou na porta')
		get_tree().change_scene("res://Scenes/Fase.tscn")
